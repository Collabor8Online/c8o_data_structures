module DataStructures
  module Definitions
    require_relative "definitions/field"
    Dir[File.join(__dir__, "definitions", "*.rb")].sort.each { |file| require file }
  end
end
