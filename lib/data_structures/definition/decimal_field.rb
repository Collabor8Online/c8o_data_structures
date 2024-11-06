module DataStructures
  class Definition
    class DecimalField < Field
      attribute :default, :float
      validates_numericality_of :default, allow_nil: true
      attribute :minimum, :float
      validates_numericality_of :minimum, allow_nil: true
      attribute :maximum, :float
      validates_numericality_of :maximum, allow_nil: true

      on_validation do |field, definition|
        options = {attributes: :value}
        options[:greater_than_or_equal_to] = definition.minimum if definition.minimum
        options[:less_than_or_equal_to] = definition.maximum if definition.maximum
        ActiveModel::Validations::NumericalityValidator.new(options).validate(field)
      end

      on_set_value do |item, value|
        item.data["value"] = Float(value)
      rescue
        item.data["value"] = value
      end
    end
  end
end
