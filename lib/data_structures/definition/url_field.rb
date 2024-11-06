module DataStructures
  class Definition
    class UrlField < Field
      attribute :default, :string, default: ""

      on_validation do |item, definition|
        options = {attributes: :value, allow_nil: !definition.required?, with: /\A#{URI::DEFAULT_PARSER.make_regexp}\z/}
        ActiveModel::Validations::FormatValidator.new(options).validate(item)
      end
    end
  end
end
