# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "bcms_settings"
    gemspec.rubyforge_project = "browsercms"
    gemspec.summary = "Global settings storage for BrowserCMS"
    gemspec.email = "github@browsermedia.com"
    gemspec.homepage = "http://browsercms.org"
    gemspec.description = "This module provides a global persisted key value store that can be used to keep configuration key value pairs"
    gemspec.authors = ["BrowserMedia"]
    gemspec.files = []
    gemspec.files += Dir["app/**/*"]
    gemspec.files += Dir["doc/**/*"]
    gemspec.files += Dir["db/migrate/[0-9]*.rb"].reject {|f| f =~ /_browsercms|_load_seed/ }
    gemspec.files += Dir["lib/bcms_settings.rb"]
    gemspec.files += Dir["lib/bcms_settings/**/*"]
    gemspec.files += Dir["rails/init.rb"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

