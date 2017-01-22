require 'streaming'
require 'google/cloud/pubsub'

class GPubSub < OutputStream


  include Settings
  include Logging

  TOPICS =  %w(commit_comments commits events followers forks issue_comments
               issue_events issues org_members pull_request_comments
               pull_requests repo_collaborators repo_labels repos users
               watchers)
 
  attr_reader :exchange, :ch

  def settings
    @settings
  end

  def configure(settings)
    #@pubsub = Google::Cloud::Pubsub.new({:project => conf(:gpubsub_project_id), 
    #                                     :keyfile => conf(:gpubsub_keyfile)})

    @pubsub = Google::Cloud::Pubsub.new({:project => 'ghtorrent-bq', 
                                         :keyfile => 'gpubsub.key'})
#    TOPICS.map do |c|
#      topic = @pubsub.create_topic c
#      debug "Topic created #{topic.name}"
#    end
#
    info "Connected to Google PubSub"
  end

  def write(msg, collection, op_type)
    ts = Time.now
#    if TOPICS.include? collection
      topic  = @pubsub.topic collection
      topic.publish msg
      info "Published msg to #{collection}: #{Time.now - ts} ms"
#    end
  end

end
