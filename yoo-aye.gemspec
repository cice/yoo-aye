# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib/', __FILE__)

Gem::Specification.new do |s|
  s.name                      = "yoo-aye"
  s.version                   = '0.0.1'
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Marian Theisen"]
  s.email                     = ["marian@cice-online.net"]
  s.homepage                  = "http://cice.github.com"
  s.summary                   = "Enhanced UI helpers and classes for Ruby on Rails"
  s.description               = "YooAye provides object-oriented UI helpers for common user interface problems."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'actionpack'
  s.add_dependency 'haml'
  s.add_dependency 'compass'
  s.add_dependency 'sprockets'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webrat'
  s.add_development_dependency 'rcov'
  s.add_development_dependency 'yard'

  s.files = Dir["**/*"] -
            Dir["coverage/**/*"] -
            Dir["rdoc/**/*"] -
            Dir["doc/**/*"] -
            Dir["sdoc/**/*"] -
            Dir["rcov/**/*"]

  s.require_path = 'lib'
end
