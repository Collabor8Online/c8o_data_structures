module DataStructures
  class Definition
    class Field < Definition
      attribute :caption, :string
      validates :caption, presence: true
      attribute :description, :string, default: ""
      attribute :required, :boolean, default: false

      def to_s = caption

      def path_name = caption.to_s.parameterize(separator: "_")

      def required? = required

      def validate_field(field)
        ActiveModel::Validations::PresenceValidator.new(attributes: :value).validate(field) if required? && field.value.blank?
        self.class.validator&.call(field, self) if required? || !field.value.blank?
      end

      def set_value_for(field, value) = self.class.setter.nil? ? set_data_value(field, value) : self.class.setter.call(field, value, self)

      def get_value_for(field) = self.class.getter.nil? ? get_data_value(field) : self.class.getter.call(field, self)

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

      def set_data_value field, value
        field.data["value"] = value
      end

      def get_data_value field
        field.data["value"] || get_default_value(field)
      end

      def get_default_value field
        field.definition.respond_to?(:default) ? field.definition.default : nil
      end
    end
  end
end
