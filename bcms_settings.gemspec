# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bcms_settings/version"

Gem::Specification.new do |s|
  s.name = %q{bcms_settings}
  s.version     = BcmsSettings::VERSION
  s.authors = ["BrowserMedia"]
  s.email = %q{github@browsermedia.com}
  s.homepage = %q{https://github.com/browsermedia/bcms_settings}
  s.description = %q{A configuration module for BrowserCMS. Provides a global persisted key value store that can be used to keep configuration key value pairs}
  s.summary = %q{Global settings storage for BrowserCMS}
  s.extra_rdoc_files = [
      "README.markdown"
    ]
  s.rdoc_options = ["--charset=UTF-8"]

  s.rubyforge_project = s.name

  s.files = Dir["{app,config,db,lib}/**/*"]
  s.files += Dir["Gemfile", "LICENSE.txt", "COPYRIGHT.txt", "GPL.txt" ]

  s.test_files += Dir["test/**/*"]
  s.test_files -= Dir['test/dummy/**/*']
  
  s.require_paths = ["lib"]

  s.add_dependency("browsercms", "< 3.6.0", ">= 3.5.0.rc3")
end




