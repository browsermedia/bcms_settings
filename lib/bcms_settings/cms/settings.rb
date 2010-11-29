module Cms
  #  Cms::Settings provides an interface for storing and retrieving
  #  arbitrary key value pairs and can be used as a persistent
  #  global configuration store.
  #
  #  Cms::Settings stores key value pairs in attributes of ActiveRecord
  #  objects. These objects, however, are not designed to be used
  #  directly. Rather, this module provides an interface for easy
  #  access to the storage objects.
  #
  #  For all installed bcms modules loaded as gems as defined by the BrowserCMS'
  #  module instalation process, this module creates a namespaced key value
  #  store automatically.
  #
  #  To know which bcms_modules the Settings module knows about:
  #  Cms::Settings.modules => [] #an empty array for new projects.
  #
  #  If a BrowserCMS project declares the following gem dependencies
  #  in environment.rb:
  #
  #  gem.bcms_s3
  #  gem.bcms_seo_sitemap
  #
  #  Client code can access the following objects automatically:
  #
  #  Cms::Settings.bcms_s3 => #<Cms::Settings: bcms_s3 => {}>
  #  Cms::Settings.bcms_seo_sitemap => #<Cms::Settings: bcms_seo_sitemap => {}>
  #
  #  To store key, value pairs just call an "=" method with an arbitrary name
  #  and value:
  #
  #  Cms::Settings.bcms_s3.account_id = "ACCOUNT_ID"
  #  Cms::Settings.bcms_s3.buckets = %w[bucket1 bucket2]
  #
  #  After adding these two values, the object looks like this:
  #
  #  Cms::Settings.bcms_s3 => <Cms::Settings: bcms_s3 => {"account_id"=>"ACCOUNT_ID", "buckets"=>["bucket1", "bucket2"]}>
  #
  #  To retrieve values:
  #
  #  Cms::Settings.bcms_s3.account_id => "ACCOUNT_ID"
  #  Cms::Settings.bcms_s3.buckets.first = "bucket1"
  #
  #  To update keys, just assign new values:
  #
  #  Cms::Settings.bcms_s3.account_id = "NEW_ID"
  #  Cms::Settings.bcms_s3.account_id => "NEW_ID"
  #
  #  To delete values, call the delete method on the settings object:
  #
  #  Cms::Settings.bcms_s3.delete("buckets")
  #  Cms::Settings.bcms_s3 => #<Cms::Settings: bcms_s3 => {"account_id"=>"NEW_ID"}
  #
  #  Keys can have almost any name, except:
  #  ["inspect", "__send__", "delete", "instance_eval", "__metaclass__", "method_missing", "__id__"]

  module Settings

    # Raised when an attempt is made to access configuration for a module
    # that has not been previously registered or is not installed.
    class ModuleNotRegistered < StandardError; end

    # Raised when an attempt is made to register a moudle that has already
    # been registered.
    class ModuleConfigurationExists < StandardError; end

    # Raised when a module name is not a valid BrowserCMS module name.
    # All module names must be lowercase, start with the bcms_ prefix and
    # must not contain whitespace or special characters. (Must be valid
    # Ruby method identifiers).
    #
    # Although the CmsModule model class validates module names, the Settings
    # module checks all names before passing them to the CmsModule and raises
    # this exception right away.
    class InvalidModuleName < StandardError; end

    extend self

    # cms managed modules are those that are declared as dependencies on
    # environment.rb. The synchronize method keeps these installed modules
    # in sync with the database automatically, creating a record for declared
    # dependencies and deleting records for bcms_modules that are no longer
    # installed.
    #
    # Cms::Settings.synchronize can be called as part of BrowserCMS'
    # initialization process.
    #
    # If this method is never called, there won't be any cms managed 'automatic'
    # modules, in which case all modules must register themselves calling
    # Cms::Settings.register("bcms_xyz")
    #`
    # Conversely, if this method is called, all installed bcms modules will
    # get a configuration object whether they need it or not.

    def synchronize
      register_modules(installed_modules - registered_modules)
      remove_modules(managed_modules - installed_modules)
    end

    # Retruns an array of module names the Cms::Settings module knows
    # about.
    #
    # [in environment.rb]
    # gem.bcms_s3
    # gem.bcms_news
    #
    # Cms::Settings.modules => ["bcms_s3", "bcms_news"]
    # Cms::Settings.register("bcms_blog")
    # Cms::Settings.modules => ["bcms_s3", "bcms_news", "bcms_blog"]

    def modules
      registered_modules
    end

    # Manually registered modules are ignored by the synchronize method.
    #
    # Cms::Settings.register("bcms_foo")
    # Cms::Settings.bcms_foo will be prsisted in the thatabase until
    # manually deleted.
    #
    # Manually registered module names must conform to BCMS's module naming
    # conventions, so this call will raise an InvalidModuleName exception:
    # Cms::Settings.register("foo") => InvalidModuleName
    #
    # Module names must also be unique:
    # Cms::Settings.modules =>  ["bcms_s3", "bcms_seo_sitemap"]
    # Cms::Settings.register("bcms_s3") => ModuleConfigurationExists

    def register(module_name)
      register_modules [module_name], false
    end

    # Destroys the CmsModule object.
    # Trying to delete a module that has not been registered raises an
    # exception:
    #
    # Cms::Settings.modules =>  ["bcms_s3", "bcms_seo_sitemap"]
    # Cms::Settings.delete("bcms_news") => ModuleNotRegistered
    #
    # At the moment it is possible to delete cms managed modules
    # although they will be automatically registered again if
    # Cms::Settings.synchronize is called.

    def delete(module_name)
      remove_modules [module_name.to_s]
    end

    # This method_missing implementation enables client code to call
    # arbitrary methods on the Settings module. Undefined methods
    # whose name does not conform to BCMS's module naming convention
    # are handled elsewhere (presumably rasing a NoMethodError exception)
    #
    # If a module with name equal to the called method has been registered
    # previously, a module method with the same name is defined (so it does not
    # go through method missing again) and a proxy object is returned.
    #
    # If the module has not been registered previously, a ModuleNotRegistered
    # exception is raised.
    #
    # Given:
    # Cms::Settings.modules => ["bcms_s3", "bcms_seo_sitemap"]
    #
    # Cms::Settings.bcms_s3 =>  #<Cms::Settings: bcms_s3 => {"account_id"=>"NEW_ID"}
    # Cms::Settings.bcms_news => ModuleNotRegistered
    # Cms::Settings.foo => NoMethodError

    def method_missing(method_id, *args)
      method_name = method_id.to_s
      unless method_name =~ CmsModule::NAME_REGEX
        super(method_id, *args)
      end
      define_method(method_name) do
        CmsModuleProxy.new(find_module(method_name))
      end
      send(method_name)
    end

    private
    def registered_modules
      CmsModule.all(:select => 'name').map { |m| m.name }
    end

    def managed_modules
      CmsModule.managed.map {|m| m.name}
    end

    def installed_modules
      Rails.configuration.gems.map do |g|
        g.name if g.name =~ /^bcms_/
      end.compact.uniq
    end

    def remove_modules(module_names)
      module_names.each do |name|
        verify_module_name(name)
        find_module(name).destroy
      end
    end

    def register_modules(module_names, managed = true)
      module_names.each do |name|
        verify_module_name(name)
        begin
          CmsModule.create!(:name => name.to_s,
                            :settings => {},
                            :cms_managed => managed)

        rescue ActiveRecord::RecordInvalid
          raise ModuleConfigurationExists,
            "The module #{name} is already registered."
        end
      end
    end

    def verify_module_name(module_name)
      unless module_name.to_s =~ CmsModule::NAME_REGEX
        raise InvalidModuleName,
          "#{module_name} is not a valid BrowserCMS module name. " +
          "No modules were registered or deleted."
      end
    end

    def find_module(module_name)
      CmsModule.find_by_name!(module_name)
    rescue ActiveRecord::RecordNotFound
      raise ModuleNotRegistered,
        "The module '#{module_name}' is not registered. " +
        "Call Cms::Settings.register(#{module_name})."
    end

    # Calls to Cms::Settings.bcms_yxz, where bcms_yxz is a previously
    # registered cms module, do not return ActiveRecord objects. Instead,
    # the CmsModule object is wrapped in an instance of the CmsModuleProxy
    # class, which provides acces to the underlying serialized hash through
    # arbitrary method names.
    class CmsModuleProxy < BlankSlate
      def initialize(cms_module)
        @cms_module = cms_module
      end

      def delete(key)
        @cms_module.settings.delete(key)
        @cms_module.save
      end

      def inspect
        "#<Cms::Settings: #{@cms_module.name} => #{@cms_module.settings.inspect}>"
      end

      def method_missing(method_id, *args)
        num_args = args.length
        method_name = method_id.to_s
        if method_name.chomp!("=")
          @cms_module.settings[method_name] = args.first
          @cms_module.save
        elsif num_args == 0
          @cms_module.settings[method_name]
        else
          super(method_id, *args)
        end
      end
    end
  end
end

