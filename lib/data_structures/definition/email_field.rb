module DataStructures
  class Definition
    class EmailField < Field
      attribute :default, :string, default: ""

      on_validation do |item, definition|
        options = {attributes: :value, allow_nil: !definition.required?, with: /\A#{URI::MailTo::EMAIL_REGEXP}\z/o}
        ActiveModel::Validations::FormatValidator.new(options).validate(item)
      end
    end
  end
end
