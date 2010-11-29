
# CmsModule objects represent bcms modules registered with the Cms:Settings module.
# These objects are not ment to be accessed directly, but through Cms:Settings'
# public interface.

class CmsModule < ActiveRecord::Base

  NAME_REGEX = /^bcms_[a-z0-9_]+/

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :name, :with => NAME_REGEX

  serialize :settings

  named_scope :managed, :conditions => {:cms_managed => true},
                        :select => 'name'
end

