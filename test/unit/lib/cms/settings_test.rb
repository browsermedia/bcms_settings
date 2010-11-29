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

  test "raises NoMethodError for undefined methods that do not conform with BCMS module naming convention " do
    assert_raise(NoMethodError) do
      Cms::Settings.wibble
    end
  end

  private

  def register_modules(*names)
    names.each {|n| CmsModule.create(:name => n, :settings => {})}
  end

end

