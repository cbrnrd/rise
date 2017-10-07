# Put all our core library files in the require path
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'core'

Gem::Specification.new do |s|
  s.name        = Rise::Constants::NAME
  s.version     = Rise::Constants::VERSION
  s.executables = ['rise', 'setup', 'console']
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = "Simple serverless website deployment"
  s.authors     = Rise::Constants::AUTHORS
  s.email       = Rise::Constants::EMAIL
  s.files       = `git ls-files`.split($/).reject { |file|
      file =~ /^server|^spec/
    }
  s.homepage    =
    'http://rubygems.org/gems/rise-cli'
  s.license       = 'MIT'

  s.add_runtime_dependency 'clipboard'
  s.add_runtime_dependency 'http'
  s.add_runtime_dependency 'paint'
  s.add_runtime_dependency 'rex-text'
  s.add_runtime_dependency 'whirly'
end
