module DataStructures
  class Definition
    class EmailField < Field
      attribute :default, :string, default: ""

      on_validation do |item, definition|
        return if !definition.required? && item.value.blank?
        options = {attributes: :value, with: /\A#{URI::MailTo::EMAIL_REGEXP}\z/o}
        ActiveModel::Validations::FormatValidator.new(options).validate(item)
      end
    end
  end
end
