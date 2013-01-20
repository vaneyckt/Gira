require './lib/github.rb'
require './lib/helpers.rb'

def on_pull_request_open(event)
  puts "opened pull request #{event.payload.number}"
end

def on_pull_request_merge(event)
  puts "merged pull request #{event.payload.number}"
end

def on_pull_request_close(event)
  puts "closed pull request #{event.payload.number}"
end


timestamp = nil

while true
  begin
    config = ConfigFile.read
    info = Github.get_pull_request_info_after(timestamp)
    info[:opened_pull_request_events].each { |event| on_pull_request_open(event) }
    info[:merged_pull_request_events].each { |event| on_pull_request_merge(event) }
    info[:closed_pull_request_events].each { |event| on_pull_request_close(event) }
    timestamp = info[:last_event_timestamp]
  rescue => e
    Logger.log('Error in main loop', e)
  end
  sleep config[:github_polling_interval_seconds]
end
