require "plumbing"
require "data_structures/version"
require "data_structures/engine"
require_relative "data_structures/configuration"
require_relative "data_structures/template"
require_relative "data_structures/template_collection"

module DataStructures
  def self.[] name
    await { @configuration[name].value }
  end

  def self.register name, class_or_name
    @configuration.register name, class_or_name
  end

  def self.reset
    @configuration.reset
  end

  @configuration = Configuration.start
end
