#!/usr/bin/env ruby

require 'streaming'

include Settings
include Logging

def settings
  @settings
end

if ARGV.size < 3
  puts 'usage: ght-mongo-streamer config.yaml [queue-name] [rk1] <rk2 ... rkn>'
  puts 'Connect to AMQP, create a queue named [queue-name] and bind'
  puts 'it to the default exchange with the provided routing keys.'
  exit(1)
end

@settings = YAML::load_file(ARGV[0])

amqp = AMQP.new
amqp.configure(settings)

q = amqp.ch.queue(ARGV[1], :auto_delete => true)
info "Created queue #{ARGV[1]}"

(2..(ARGV.size - 1)).each do |rk|
  q.bind(amqp.exchange, :routing_key => ARGV[rk])
  info "Binding for key #{ARGV[rk]} created"
end

info 'Press any key to stop...'
sleep(2)

q.subscribe do |delivery_info, properties, payload|
  puts "#{delivery_info.routing_key}: #{payload}"
end

STDIN.getc.chr
