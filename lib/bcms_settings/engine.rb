require 'browsercms'

module BcmsSettings
  class Engine < Rails::Engine
    include Cms::Module
    
    initializer 'bcms_settings.register_modules' do
      require 'bcms_settings/cms/settings'
      Cms::Settings.synchronize
    end
  end
end