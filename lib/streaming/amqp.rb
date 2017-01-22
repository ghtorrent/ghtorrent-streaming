require 'streaming'
require 'bunny'

class AMQP < OutputStream

  include Settings
  include Logging

  attr_reader :exchange, :ch

  def settings
    @settings
  end

  def configure(settings)
    @settings = settings
    conn = Bunny.new(:host => conf(:amqp_host),
                     :port => conf(:amqp_port),
                     :username => conf(:amqp_username),
                     :password => conf(:amqp_password))
    conn.start

    @ch  = conn.create_channel
    info "Connection to RabbimMQ at #{conf(:amqp_host)} succeded"

    @exchange = ch.topic(conf(:amqp_exchange), :durable => true,
                        :auto_delete => false)
    info "Exchange #{conf(:amqp_exchange)} attached"

    @persistent = conf(:amqp_persistent)
    info "Default msg persistence: #{conf(:amqp_persistent)}"

  end

  def write(msg, collection, op_type)
    ts = Time.now
    rk_prefix = case collection
                  when 'events'
                    'evt'
                  else
                    'ent'
                end

    rk_suffix = case collection
                  when 'events'
                    JSON.parse(msg)['type'].downcase.split(/event/)[0]
                  else
                    collection
                end

    rk = "#{rk_prefix}.#{rk_suffix}.#{op_type}"
    debug "Publishing msg with routing key #{rk}: #{Time.now - ts} ms"

    @exchange.publish msg,
                      :persistent => @persistent,
                      :routing_key => rk
  end

end
