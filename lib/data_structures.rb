require "plumbing"
require "data_structures/version"
require "data_structures/engine"

module DataStructures
  def self.[](name) = await { @configuration[name].value }

  def self.register(name, class_or_name) = @configuration.register name, class_or_name

  def self.class_for(name) = await { @configuration.class_for name }

  def self.load(config) = @item_loader.call config

  def self.type_for(klass) = await { @configuration.type_for klass }

  def self.reset = @configuration.reset

  require_relative "data_structures/configuration"
  require_relative "data_structures/template_collection"
  require_relative "data_structures/item_loader"
  require_relative "data_structures/template"
  require_relative "data_structures/definitions"
  @configuration = Configuration.start
  @item_loader = ItemLoader.new
end
