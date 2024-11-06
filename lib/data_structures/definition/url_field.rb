module DataStructures
  class Definition
    class UrlField < Field
      attribute :default, :string, default: ""

      on_validation do |item, definition|
        return if !definition.required? && item.value.blank?
        options = {attributes: :value, with: /\A#{URI::DEFAULT_PARSER.make_regexp}\z/}
        ActiveModel::Validations::FormatValidator.new(options).validate(item)
      end
    end
  end
end
