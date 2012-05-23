Rails.application.routes.draw do

  mount BcmsSettings::Engine => "/bcms_settings"
	mount_browsercms
end
