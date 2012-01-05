# Cms::Settings for BrowserCMS projects

Cms::Settings provides an interface for storing and retrieving
arbitrary key value pairs and can be used as a persistent
global configuration store.

Cms::Settings stores key value pairs in attributes of ActiveRecord
objects. These objects, however, are not designed to be used
directly. Rather, this module provides an interface for easy
access to the storage objects.

For all installed bcms modules loaded as gems as defined by the BrowserCMS'
module instalation process, this module can create a namespaced key value
store automatically.

## Installation

The Settings module installs like most other BrowserCMS modules
(http://guides.browsercms.org/installing_modules.html)
except that it does not define any new routes and requires one
additional step.

    gem install bcms_settings
	rails generate cms:install bcms_settings
	
## Usage

### Accessing the settings

If a BrowserCMS project declares the following gem dependencies
in Gemfile:

    gem "bcms_s3"
    gem "bcms_seo_sitemap"

Client code can access the following objects automatically:

    Cms::Settings.bcms_s3
    => #<Cms::Settings: bcms_s3 => {}>

    Cms::Settings.bcms_seo_sitemap
    => #<Cms::Settings: bcms_seo_sitemap => {}>

if you uninstall bcms_xyz (by removing it from environment.rb)
the corresponding settings object will be destroyed for you.

To know which bcms_modules the Settings module knows about:

    Cms::Settings.modules => ['bcms_s3', 'bcms_seo_sitemap']

### Storing, retrieving and deleting values

To store values in these objects just call arbitrary methods (which will become
keys) and assign values. It is possile to store scalar values, arrays and
hashes. Values ar persisted automatically.

    Cms::Settings.bcms_s3.account_id = "ACCOUNT_ID"
    Cms::Settings.bcms_s3.buckets = %w[bucket1 bucket2]

After adding these two values, the object looks like this:

    Cms::Settings.bcms_s3
    => #<Cms::Settings: bcms_s3 => {"account_id"=>"ACCOUNT_ID", "buckets"=>["bucket1", "bucket2"]}>

To retrieve values:

    Cms::Settings.bcms_s3.account_id
    => "ACCOUNT_ID"

    Cms::Settings.bcms_s3.buckets.first
    => "bucket1"

To update keys, just assign new values:

    Cms::Settings.bcms_s3.account_id = "NEW_ID"
    Cms::Settings.bcms_s3.account_id
    => "NEW_ID"

To delete values, call the delete method on the settings object:

    Cms::Settings.bcms_s3.delete("buckets")
    Cms::Settings.bcms_s3
    => #<Cms::Settings: bcms_s3 => {"account_id"=>"NEW_ID"}

Keys can have almost any name, except for these:
    inspect, __send__, delete, instance_eval, __metaclass__, method_missing


### Registering and deleting modules

As of 0.1.0, you no longer need to register BrowserCMS modules explicitly, or use the Cms::Settings.synchronzie method. This module will automatically detected other BrowserCMS modules and create a setting storage for them. You can explicitly create new storages though for other settings. 

For example, to register a 'fake' modules:

    Cms::Settings.register("bcms_some_fake_module")

then you can store, retrieve and delete arbitrary values:

    config = Cms::Settings.bcms_my_module
    config.client = "Widgets INC"
    config.url = "http://example.com"
    config.sections = %w[A B C]
    config.url
    => "http://example.com
    config.delete("url")
    config.url
    => nil

In the background, what 'registering a module' does is create an object where
to store values, so you can request storage to the Settings module for
whatever purpose you like, providing that:

1. The name you are trying to register is a valid BrowserCMS module
name and a valid Ruby method identifier, so this is valid:

      Cms::Settings.register("bcms_my_config")

  but this is not:

      Cms::Settings.register("My Config")

2. The name you are trying to register has not been previously registered.
Names passed to the register method must be unique.


To delete modules:

    Cms::Settings.delete("bcms_my_config") #all values will be lost

    Cms::Settings.bcms_by_config #Raises an exception
    => ModuleNotRegistered

