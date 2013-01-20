require 'yaml'

module Logger
  def Logger.get_path
    "#{Dir.pwd}/log"
  end

  def Logger.log(message, exception = nil)
    path = get_path
    File.open(path, 'a') { |f| f << "#{Time.now} (#{Time.now.to_i})\n======================================\n#{message} \n\n" } if exception.nil?
    File.open(path, 'a') { |f| f << "#{Time.now} (#{Time.now.to_i})\n======================================\n#{message} - #{exception} - #{exception.backtrace} \n\n" } if !exception.nil?
  end
end

module ConfigFile
  def ConfigFile.get_path
    "#{Dir.pwd}/config/config.yaml"
  end

  def ConfigFile.read
    path = get_path
    data = YAML.load(File.read(path)) if File.exists?(path)
    data = !data ? {} : data
  end
end

module Repository
  def Repository.get_id
    config = ConfigFile.read
    config[:github_ssh_repository].split('github.com:').last.split('.git').first
  end
end
