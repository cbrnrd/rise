Gem::Specification.new do |s|
  s.name        = 'rise'
  s.version     = '0.1.0'
  s.executables << 'rise'
  s.date        = '2017-10-04'
  s.summary     = "Simple serverless website deployment"
  s.authors     = ["Carter Brainerd"]
  s.email       = '0xCB@protonmail.com'
  s.files       = `git ls-files`.split($/).reject { |file|
      file =~ /^server|rise.gemspec/
    }
  s.homepage    =
    'http://rubygems.org/gems/rise-cli'
  s.license       = 'MIT'
end
