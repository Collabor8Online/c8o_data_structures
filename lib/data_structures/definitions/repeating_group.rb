module DataStructures
  module Definitions
    class RepeatingGroup
      def initialize items: []
        @items = items
      end

      attr_reader :items
    end
  end
end
