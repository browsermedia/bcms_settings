require 'cms/module_installation'

class BcmsSettings::InstallGenerator < Cms::ModuleInstallation

  def copy_migrations
     rake 'bcms_settings:install:migrations'
  end

end
