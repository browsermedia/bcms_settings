# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bcms_settings}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["BrowserMedia"]
  s.date = %q{2010-11-29}
  s.description = %q{This module provides a global persisted key value store that can be used to keep configuration key value pairs}
  s.email = %q{github@browsermedia.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README"
  ]
  s.files = [
    "app/controllers/application_controller.rb",
     "app/helpers/application_helper.rb",
     "app/models/cms_module.rb",
     "db/migrate/20101129011429_create_cms_modules.rb",
     "doc/README_FOR_APP",
     "lib/bcms_settings.rb",
     "lib/bcms_settings/cms/settings.rb",
     "lib/bcms_settings/routes.rb",
     "rails/init.rb"
  ]
  s.homepage = %q{http://browsercms.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{browsercms}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Global settings storage for BrowserCMS}
  s.test_files = [
    "test/performance/browsing_test.rb",
     "test/test_helper.rb",
     "test/unit/cms_module_test.rb",
     "test/unit/lib/cms/settings_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<browsercms>, ["~> 3.1.2"])
    else
      s.add_dependency(%q<browsercms>, ["~> 3.1.2"])
    end
  else
    s.add_dependency(%q<browsercms>, ["~> 3.1.2"])
  end
end

