# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'coalla/cms/version'

Gem::Specification.new do |s|
  s.name = 'coalla-cms'
  s.version = Coalla::Cms::VERSION
  s.authors = ['coalla']
  s.email = ['dev@coalla.ru']
  s.homepage = 'http://coalla.ru'
  s.summary = 'Coalla CMS gem'
  s.description = 'Coalla CMS gem'

  s.rubyforge_project = 'coalla-cms'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'rails', '~> 7.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'listen'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'jquery-timepicker-addon-rails'
  s.add_dependency 'js-routes'
  s.add_dependency 'devise'
  s.add_dependency 'haml'
  s.add_dependency 'sass-rails'
  s.add_dependency 'carrierwave'
  s.add_dependency 'ckeditor'
  s.add_dependency 'mini_magick'
  s.add_dependency 'sanitize'
  s.add_dependency 'remotipart'
  s.add_dependency 'rmagick'
  s.add_dependency 'will_paginate'
  s.add_dependency 'standalone_typograf', '~> 3.0.2'
  s.add_dependency 'meta-tags', '~> 2.13'


  s.required_ruby_version = '>= 2.3'
end
