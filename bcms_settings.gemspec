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

  s.rubyforge_project = "bcms_settings"

  s.files         = `git ls-files`.split("\n")
  # Exclude files required for the 'dummy' Rails app
  s.files         -= Dir['config/**/*', 'public/**/*', 'config.ru',
                         'db/migrate/*browsercms*',
                         'db/seeds.rb',
                         'script/**/*',
                         'app/controllers/application_controller.rb',
                         'app/helpers/application_helper.rb',
                         'app/layouts/templates/**/*'

  ]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency(%q<browsercms>, ["~> 3.3.0"])
end




