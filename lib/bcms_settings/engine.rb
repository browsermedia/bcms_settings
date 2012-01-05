require 'browsercms'

module BcmsSettings
  class Engine < Rails::Engine
    include Cms::Module
  end
end