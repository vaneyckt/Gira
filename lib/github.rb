require 'octokit'
require '/lib/helpers.rb'

module Gira
  module Github
    def Github.get_pull_request_events_after(event_id)
      events = get_repository_events_after(event_id)
      pull_request_events = events.select { |event| event.type == 'PullRequestEvent' }
      {:last_event_id => events.last.id, :pull_request_events => pull_request_events}
    end

    def Github.get_repository_events_after(event_id)
      events = []
      finished = false

      (1..10).each do |page|
        if !finished
          page_events = get_repository_events(:page => page)
          page_events.each do |page_event|
            finished = finished || (page_event.id == event_id)
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
end
