require "plumbing"
require "data_structures/version"
require "data_structures/engine"

module DataStructures
  def self.[] name
    await { @configuration[name].value }
  end

  def self.register name, class_or_name
    @configuration.register name, class_or_name
  end

  def self.class_for name
    await { @configuration.class_for name }
  end

  def self.load config
    @template_loader.call config
  end

  def self.reset
    @configuration.reset
  end

  require_relative "data_structures/configuration"
  require_relative "data_structures/template_collection"
  require_relative "data_structures/template_loader"
  require_relative "data_structures/template"
  require_relative "data_structures/definitions"
  @configuration = Configuration.start
  @template_loader = TemplateLoader.new
end
