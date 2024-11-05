require "plumbing"
require "data_structures/version"
require "data_structures/engine"

module DataStructures
  def self.[](name) = await { @configuration[name].value }

  def self.register(name, class_or_name) = @configuration.register name, class_or_name

  def self.class_for(name) = await { @configuration.class_for name }

  def self.type_for(klass) = await { @configuration.type_for klass }

  def self.registered_types = await { @configuration.registered_types }

  def self.attributes_for(type) = await { @configuration.attributes_for(type) }

  def self.reset = @configuration.reset

  require_relative "data_structures/definition"
  require_relative "data_structures/definition/container"
  require_relative "data_structures/definition/template"
  require_relative "data_structures/definition/field"
  Dir[File.join(__dir__, "data_structures/definition", "*.rb")].sort.each { |file| require file }
  require_relative "data_structures/configuration"
  require_relative "data_structures/template_collection"
  @configuration = Configuration.start
end
