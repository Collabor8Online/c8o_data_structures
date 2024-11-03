module DataStructures
  class Definition
    class NumberField < Field
      attribute :default, :integer
      validates_numericality_of :default, only_integer: true, allow_nil: true
      attribute :minimum, :integer
      validates_numericality_of :minimum, only_integer: true, allow_nil: true
      attribute :maximum, :integer
      validates_numericality_of :maximum, only_integer: true, allow_nil: true

      on_validation do |item, definition|
        options = {attributes: :value, only_integer: true}
        options[:greater_than_or_equal_to] = definition.minimum if definition.minimum
        options[:less_than_or_equal_to] = definition.maximum if definition.maximum
        ActiveModel::Validations::NumericalityValidator.new(options).validate(item)
      end
    end
  end
end
