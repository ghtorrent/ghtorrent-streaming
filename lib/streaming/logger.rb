require 'logger'
require 'time'

module Logging

  include Settings

  def error(msg)
    log(:warn, msg)
  end

  def warn(msg)
    log(:warn, msg)
  end

  def info(msg)
    log(:info, msg)
  end

  def debug(msg)
    log(:debug, msg)
  end

  # Default logger
  def loggerr
    @logger ||= proc do

      logger = if conf(:logging_file).casecmp('stdout')
                 Logger.new(STDOUT)
               elsif conf(:logging_file).casecmp('stderr')
                 Logger.new(STDERR)
               else
                 Logger.new(conf(:logging_file))
               end

      logger.level =
          case conf(:logging_level).downcase
            when 'debug' then
              Logger::DEBUG
            when 'info' then
              Logger::INFO
            when 'warn' then
              Logger::WARN
            when 'error' then
              Logger::ERROR
            else
              Logger::INFO
          end

      logger.formatter = proc do |severity, time, progname, msg|
        "#{severity}, #{time.iso8601}, ght-streamer -- #{msg}\n"
      end
      logger
    end.call

    @logger
  end

  private

  def retrieve_caller
    @logprefixes ||= Hash.new

    c = caller[2]
    unless @logprefixes.key? c
      file_path = c.split(/:/)[0]
      @logprefixes[c] = File.basename(file_path) + ': '
    end

    @logprefixes[c]

  end

  # Log a message at the given level.
  def log(level, msg)

    case level
      when :fatal then
        loggerr.fatal (retrieve_caller + msg)
      when :error then
        loggerr.error (retrieve_caller + msg)
      when :warn then
        loggerr.warn (retrieve_caller + msg)
      when :info then
        loggerr.info (retrieve_caller + msg)
      when :debug then
        loggerr.debug (retrieve_caller + msg)
      else
        loggerr.debug (retrieve_caller + msg)
    end
  end
end
