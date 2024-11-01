module DataStructures
  class Definition
    class DropDownField < Field
      attr_reader :options
      attribute :default, :string, default: ""
      validate :default do |drop_down_field|
        drop_down_field.errors.add :default, :is_not_legal_default unless drop_down_field.default.blank? || drop_down_field.options.include?(drop_down_field.default)
      end

      def initialize(options: {}, **)
        super(**)
        @options = options.transform_keys(&:to_s).freeze
      end
    end
  end
end
