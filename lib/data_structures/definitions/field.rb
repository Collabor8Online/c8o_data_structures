module DataStructures
  module Definitions
    class Field
      def initialize caption:, description: "", required: false, default: ""
        @caption = caption || raise(ArgumentError, "caption is required")
        @description = description
        @required = required
        @default = default
      end

      attr_reader :caption, :description, :required, :default

      def required? = required
    end
  end
end
