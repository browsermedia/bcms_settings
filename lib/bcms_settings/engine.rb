require 'browsercms'

module BcmsSettings
  class Engine < Rails::Engine
    include Cms::Module
    
    isolate_namespace BcmsSettings

    initializer 'bcms_settings', :after=>'disable_dependency_loading' do
      require 'bcms_settings/cms/settings'
      Cms::Settings.synchronize
    end
  end
end