require 'test_helper'

class CmsModuleTest < ActiveSupport::TestCase

  def valid_attributes
    {
      :name => 'bcms_blog',
      :settings => {}
    }
  end

  def setup
    @blog_module = CmsModule.new(valid_attributes)
  end

  test "should be valid with valid attributes" do
    assert @blog_module.valid?
  end

  test "should not be valid without a cms_name" do
    @blog_module.name = ""
    assert !@blog_module.valid?
  end

  test "should not be valid if cms_name is not a valid BCMS module name" do
    @blog_module.name = "bcms s3"
    assert !@blog_module.valid?
    @blog_module.name = "BCMS_S3"
    assert !@blog_module.valid?
    @blog_module.name = "s3"
    assert !@blog_module.valid?
    @blog_module.name = "bcms-s3"
    assert !@blog_module.valid?
    @blog_module.name = "bcms_s3"
    assert @blog_module.valid?
  end

  test "should not be valid if cms_name is not unique" do
    @blog_module.save
    assert !CmsModule.new(valid_attributes).valid?
  end

end

