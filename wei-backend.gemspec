$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new 'wei-backend' do |s|
  s.description       = 'wei-backend is a DSL for quickly creating weixin open platform backend system.'
  s.summary           = 'Best DSL for weixin development'
  s.authors           = ['Wang Chao']
  s.email             = 'cwang8023@gmail.com'
  s.homepage          = 'https://github.com/charleyw/weixin-sinatra'
  s.license           = 'MIT'
  s.files             = `git ls-files`.split("\n") - %w[.gitignore .travis.yml .ruby-version .ruby-gemset] - Dir['examples/**/*','spec/**/*']
  s.test_files        = s.files.select { |p| p =~ /^spec\/.*_spec.rb/ }
  s.version           = `git tag | tail -1`

  s.add_dependency 'sinatra', '~> 1.4.4'
  s.add_dependency 'nokogiri', '~> 1.6.0'
  s.add_dependency 'haml', '~> 4.0.4'
  s.add_dependency 'json', '~> 1.8'
end