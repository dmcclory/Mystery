# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name         = "mystery"
  gem.version      = "0.0.1"

  gem.platform     = Gem::Platform::RUBY

  gem.summary      = "convenient tracing for debugging"
  gem.description  = "set_trace_func lets you drink from the firehose - you can see everything at every step of the execution of a program. Mystery is a filter, helping developers troubleshoot bugs by letting them narrow down the search space to areas where the bugs are likely."

  gem.licenses     = ['MIT']

  gem.authors      = ['Dan McClory']
  gem.email        = ['danmcclory@gmail.com']
  gem.homepage     = 'https://github.com/dmcclory'

  gem.required_ruby_version     = '>= 2.0.0'
  gem.required_rubygems_version = '>= 1.3.6'

  gem.files        = ['README.md', 'lib/**/*', 'spec/**/*']

  gem.require_path = 'lib'
end
