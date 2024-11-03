module DataStructures
  class Definition
    class Field < Definition
      attribute :caption, :string
      validates :caption, presence: true
      attribute :description, :string, default: ""
      attribute :required, :boolean, default: false

      def to_s = caption

      def required? = required

      def validate_item(item)= self.class.validator&.call(item, self)

      def set_value_for(item, value) = self.class.setter.nil? ? set_item_data_value(item, value) : self.class.setter.call(item, value, self)

      def get_value_for(item) = self.class.getter.nil? ? get_item_data_value(item) : self.class.getter.call(item, self)

      class << self
        attr_reader :validator, :setter, :getter

        def on_validation &block
          @validator = block
        end

        def on_set_value &block
          @setter = block
        end

        def on_get_value &block
          @getter = block
        end
      end

      private

      def set_item_data_value item, value
        item.data["value"] = value
      end

      def get_item_data_value item
        item.data["value"] || get_item_default_value(item)
      end

      def get_item_default_value item
        item.definition.respond_to?(:default) ? item.definition.default : nil
      end
    end
  end
end
