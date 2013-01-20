Gem::Specification.new do |s|
  s.name        = 'gira'
  s.version     = '1.0.0'
  s.date        = '2013-01-20'
  s.summary     = "A Ruby application that allows for asynchronous callbacks of Github pull request events."
  s.description = "A Ruby application that allows for asynchronous callbacks of Github pull request events."
  s.authors     = ["Tom Van Eyck"]
  s.email       = 'tomvaneyck@gmail.com'
  s.homepage    = 'https://github.com/vaneyckt/Gira'

  s.add_runtime_dependency 'octokit', '>= 1.22.0'
  s.add_runtime_dependency 'daemons', '>= 1.1.9'
end
