require 'streaming'

class AzureSbHttp < OutputStream

  include Settings

  def settings
    @settings
  end

  def configure(settings)
    @settings = settings

    Azure.config.sb_namespace  = conf(:sb_namespace, false)
    Azure.config.sb_access_key = conf(:sb_key, false)

    @service_bus = Azure::ServiceBus::ServiceBusService.new

    @topic = Azure::ServiceBus::Topic.new(conf(:sb_topic))
    @topic.default_message_time_to_live = conf(:sb_ttl)
    @topic.max_size_in_megabytes = 1024

    if @service_bus.list_topics.find{|t| t.name == conf(:sb_topic)}.nil?
      @service_bus.create_topic(topic)
    end

  end

  def write(msg)
    @service_bus.send_topic_message(@topic, msg)
  end

end