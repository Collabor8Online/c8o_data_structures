module DataStructures
  module Definitions
    class Section
      def initialize items: []
        @items = items
      end

      attr_reader :items
    end
  end
end
