require 'streaming'
require 'bunny'

class AMQP < OutputStream

  include Settings

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

    ch  = conn.create_channel
    STDERR.puts "Connection to #{conf(:amqp_host)} succeded"

    @exchange = ch.topic(conf(:amqp_exchange), :durable => true,
                        :auto_delete => false)

  end

  def write(msg)
    @exchange.publish msg, :persistent => true, :routing_key => 'mongo'
  end

end