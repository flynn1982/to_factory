require "to_factory/version"
require "to_factory/config"
require "to_factory/generator"
require "to_factory/collation"
require "to_factory/file_writer"
require "to_factory/finders/model"
require "to_factory/finders/factory"
require "to_factory/definition_group"
require "to_factory/file_sync"
require "to_factory/parsing/file"

module ToFactory
  class MissingActiveRecordInstanceException < Exception;end

  class << self
    def from_instance(instance, name=nil)
      name ||= instance.class.name
      Generator.new(instance, name).to_factory
    end

    def new_syntax?
      require "factory_girl"
      if FactoryGirl::VERSION.to_s[0].to_i > 1
        true
      else
        false
      end
    rescue NameError
      false
    end
  end
end

public

def ToFactory(args=nil)
  meth = ToFactory::FileSync.method(:new)
  sync = args ? meth.call(args) : meth.call
  sync.perform
end

if defined?(Rails)
  unless Rails.respond_to?(:configuration)
    #FactoryGirl 1.3.x expects this method, but it isn't defined in Rails 2.0.2
    def Rails.configuration
      OpenStruct.new
    end
  end
end
