module Cms::Routes
  def routes_for_bcms_settings
    namespace(:cms) do |cms|
      #cms.content_blocks :settings
    end  
  end
end
