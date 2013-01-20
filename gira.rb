require './lib/github.rb'

module Gira
  while true
    begin
      pull_request_events = Github.get_pull_request_events_after(nil)
      pull_request_events.each do |event|
        puts events.to_s
        puts "\n"
      end
    rescue => e
      Logger.log('Error in main loop', e)
    end
    sleep config[:github_polling_interval_seconds]
  end
end
