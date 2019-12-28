require 'yaml'
require 'tmpdir'

module Settings

  CONFIGKEYS = {
      :sb_namespace  => 'azure.servicebus.namespace',
      :sb_key        => 'azure.servicebus.key',
      :sb_topic      => 'azure.servicebus.topic',
      :sb_ttl        => 'azure.servicebus.ttl',

      :amqp_host => 'amqp.host',
      :amqp_port => 'amqp.port',
      :amqp_username => 'amqp.username',
      :amqp_password => 'amqp.password',
      :amqp_exchange => 'amqp.exchange',
      :amqp_persistent => 'amqp.persistent',

      :outputs       => 'outputs',

      :gpubsub_project_id => 'gpubsub.project_id',
      :gpubsub_keyfile => 'gpubsub.keyfile',
      
      :logging_level => 'logging.level',
      :logging_file  => 'logging.file',

      :mongo_host => "mongo.host",
      :mongo_port => "mongo.port",
      :mongo_db => "mongo.db",
      :mongo_username => "mongo.username",
      :mongo_passwd => "mongo.password",
      :mongo_replicas => "mongo.replicas"
  }

  DEFAULTS = {
      :sb_namespace  => 'ghtorrent',
      :sb_key        => 'foobar',
      :sb_topic      => 'topic',
      :sb_ttl        => 'PT1M',

      :amqp_host => 'localhost',
      :amqp_port => 5672,
      :amqp_username => 'github',
      :amqp_password => 'github',
      :amqp_exchange => 'github',
      :amqp_persistent => false,

      :outputs       => [],

      :gpubsub_project_id => '',
      :gpubsub_keyfile => 'gpubsub.key',

      :logging_level => 'info',
      :logging_file  => 'stdout',

      :mongo_host => "localhost",
      :mongo_port => "27017",
      :mongo_db => "github",
      :mongo_username => "ghtorrent",
      :mongo_passwd => "",
      :mongo_replicas => ""
  }

  def conf(key, use_default = true)
    begin
      a = read_value(settings, CONFIGKEYS[key])
      if a.nil? && use_default
        DEFAULTS[key]
      else
        a
      end
    rescue StandardError => e
      if use_default
        DEFAULTS[key]
      else
        raise e
      end
    end
  end

  def merge(more_keys)
    more_keys.each { |k, v| CONFIGKEYS[k] = v }
  end

  def merge_config_values(config, values)
    values.reduce(config) { |acc, k|
      acc.merge_recursive write_value(config, CONFIGKEYS[k[0]], k[1])
    }
  end

  def override_config(config_file, setting, new_value)
    merge_config_values(config_file, {setting => new_value})
  end

  def settings
    raise StandardError.new('Unimplemented')
  end

  private

  def read_value(from, key)
    return from if key.nil? or key == ""

    key.split(/\./).reduce({}) do |acc, x|
      unless acc.nil?
        if acc.empty?
          # Initial run
          acc = from[x]
        else
          if acc.has_key?(x)
            acc = acc[x]
          else
            # Some intermediate key does not exist
            return nil
          end
        end
        acc
      else
        # Some intermediate key returned a null value
        # This indicates a malformed entry
        return nil
      end
    end
  end

  # Overwrite an existing +key+ whose format is "foo.bar" (where a dot
  # represents one level deep in the hierarchy) in hash +to+ with +value+.
  # If the key does not exist, it will be added at the appropriate depth level
  def write_value(to, key, value)
    return to if key.nil? or key == ""

    prev = nil
    key.split(/\./).reverse.each {|x|
      a = Hash.new
      a[x] = if prev.nil? then value else prev end
      prev = a
      a
    }

    to.merge_recursive(prev)
  end

end

class Hash
  def merge_recursive(o, overwrite = true)
    merge(o) do |_, x, y|
      if x.respond_to?(:merge_recursive) && y.is_a?(Hash)
        x.merge_recursive(y)
      else
        if overwrite then
          y
        else
          [x, y].flatten.uniq
        end
      end
    end
  end
end
