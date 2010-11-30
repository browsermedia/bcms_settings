require 'test_helper'
require 'mocha'

class SettingsTest < ActiveSupport::TestCase

  def setup
    @modules = %w[bcms_blog bcms_s3 bcms_seo_sitemap]
  end

  test "modules returns an array of registered module names"do
    register_modules *@modules
    assert_equal @modules, Cms::Settings.modules
  end

  test "synchronize registers modules from loadaed gems" do
    Cms::Settings.expects(:installed_modules).returns(@modules).twice
    Cms::Settings.synchronize
    assert_equal @modules, Cms::Settings.modules
  end

  test "synchronize deletes modules not loaded as gems" do
    register_modules *@modules
    installed_modules = %w[bcms_blog bcms_s3]
    Cms::Settings.expects(:installed_modules).returns(installed_modules).twice
    Cms::Settings.synchronize
    assert_equal installed_modules, Cms::Settings.modules
  end

  test "register registers a module and flags it as non managed" do
    Cms::Settings.register('bcms_blog')
    assert_equal ['bcms_blog'], Cms::Settings.modules
    assert !CmsModule.first.cms_managed?
  end

  test "register raises InvalidModuleName if name does not conform to BCMS's module naming convention" do
    assert_raise(Cms::Settings::InvalidModuleName) do
      Cms::Settings.register("invalid name")
    end
  end

  test "register raises ModuleConfigurationExists if the module is already registered" do
    register_modules *@modules
    assert_raise(Cms::Settings::ModuleConfigurationExists) do
      Cms::Settings.register('bcms_blog')
    end
  end

  test "synchronize does not delete modules flagged as not managed" do
    Cms::Settings.register('bcms_blog')
    Cms::Settings.synchronize
    assert_equal ['bcms_blog'], Cms::Settings.modules
  end

  test "delete destroys the module" do
    Cms::Settings.register('bcms_blog')
    assert_equal ['bcms_blog'], Cms::Settings.modules
    Cms::Settings.delete('bcms_blog')
    assert_equal [], Cms::Settings.modules
  end

  test "trying to delete a module that has not been registered raises ModuleNotRegistered" do
    assert_raise(Cms::Settings::ModuleNotRegistered) do
      Cms::Settings.delete('bcms_blog')
    end
  end

  test "defines methods for accessing user registered modules" do
    Cms::Settings.register('bcms_blog')
    assert !Cms::Settings.respond_to?(:bcms_blog)
    Cms::Settings.bcms_blog
    assert Cms::Settings.respond_to?(:bcms_blog)
  end

  test "defines methods for cms managed modules" do
    Cms::Settings.expects(:installed_modules).returns(@modules).twice
    Cms::Settings.synchronize
    assert !Cms::Settings.respond_to?(:bcms_s3)
    Cms::Settings.bcms_s3
    assert Cms::Settings.respond_to?(:bcms_s3)
    assert !Cms::Settings.respond_to?(:bcms_seo_sitemap)
    Cms::Settings.bcms_seo_sitemap
    assert Cms::Settings.respond_to?(:bcms_seo_sitemap)
  end

  test "raises ModuleNotRegistered if a method with name of not installed module is called" do
    assert_raise(Cms::Settings::ModuleNotRegistered) do
      Cms::Settings.bcms_not_registered
    end
  end

  test "raises NoMethodError for undefined methods that do not conform with BCMS module naming convention" do
    assert_raise(NoMethodError) do
      Cms::Settings.wibble
    end
  end

  #TODO: The following tests for CmsModuleProxy should probably be split to a different file.

  test "should store values for arbitrary keys" do
    register_modules 'bcms_s3'
    Cms::Settings.bcms_s3.account_id = "ACCOUNT_ID"
    assert_equal "ACCOUNT_ID", Cms::Settings.bcms_s3.account_id
  end

  test "sohould store arrays" do
    register_modules 'bcms_blog'
    config = Cms::Settings.bcms_blog
    config.options = %w[A B C]
    assert_equal "C", config.options.last
  end

  test "should update values" do
    register_modules 'bcms_blog'
    config = Cms::Settings.bcms_blog
    config.authors = ['Sue', 'Mike']
    assert_equal 'Sue', config.authors[0]
    config.authors[0] = 'Zoe'
    assert_equal 'Zoe', config.authors[0]
  end

  test "should destroy key value pairs" do
    register_modules 'bcms_wibble'
    config = Cms::Settings.bcms_wibble
    config.depth = 3
    assert_equal 3, config.depth
    config.delete("depth")
    assert !config.depth
  end

  test "should raise NoMethodError for methods with arity > 1" do
    register_modules 'bcms_wibble'
    assert_raise(NoMethodError) do
      Cms::Settings.bcms.wibble.something('a', 'b')
    end
  end

  private
  def register_modules(*names)
    names.each {|n| CmsModule.create(:name => n, :settings => {})}
  end

end

