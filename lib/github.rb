require 'octokit'
require './lib/helpers.rb'

module Github
  def Github.get_pull_request_info_after(timestamp)
    events = get_repository_events_after(timestamp)
    pull_request_events = events.select { |event| event.type == 'PullRequestEvent' }

    info = {}
    info[:last_event_timestamp] = events.last.created_at
    info[:opened_pull_request_events] = pull_request_events.select { |event| event.payload.action == 'opened' || event.payload.action == 'reopened'}
    info[:merged_pull_request_events] = pull_request_events.select { |event| event.payload.action == 'closed' && event.payload.pull_request.merged == true }
    info[:closed_pull_request_events] = pull_request_events.select { |event| event.payload.action == 'closed' && event.payload.pull_request.merged == false }
    info
  end

  def Github.get_repository_events_after(timestamp)
    events = []
    finished = false

    (1..10).each do |page|
      if !finished
        page_events = get_repository_events(:page => page)
        page_events.each do |page_event|
          finished ||= !timestamp.nil? and page_event.created_at <= timestamp
          events << page_event if !finished
        end
        sleep 5
      end
    end
    events.sort { |x,y| x.created_at <=> y.created_at }
  end

  def Github.get_repository_events(options = {})
    begin
      config = ConfigFile.read
      respository_id = Repository.get_id
      client = Octokit::Client.new(:login => config[:github_login], :password => config[:github_password])
      client.repository_events(respository_id, options)
    rescue => e
      Logger.log('Error when trying to get repository events', e)
      sleep 5
      retry
    end
  end
end
