# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

BcmsSettings::Application.load_tasks

# Otherwise, this enabled Bundler to build your gem
require 'bundler'
Bundler::GemHelper.install_tasks