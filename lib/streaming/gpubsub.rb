require 'streaming'
require 'google/cloud/pubsub'

class GPubSub < OutputStream

  include Settings
  include Logging

  attr_reader :exchange, :ch

  def settings
    @settings
  end

  def configure(settings)
    @pubsub = Google::Cloud::Pubsub.new project: conf(:gpubsub_project_id)

    %w(commit_comments commits events followers forks issue_comments
       issue_events issues org_members pull_request_comments
       pull_requests repo_collaborators repo_labels repos users
       watchers).map do |c|
      topic = pubsub.create_topic c
      puts "Topic created #{topic.name}"
    end

  end

  def write(msg, collection, op_type)
    topic  = @pubsub.topic collection
    topic.publish msg
  end

end
