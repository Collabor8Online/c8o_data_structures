module DataStructures
  class Definition
    class EmailField < Field
      attribute :default, :string, default: ""

      on_validation do |field, definition|
        options = {attributes: :value, with: /\A#{URI::MailTo::EMAIL_REGEXP}\z/o}
        ActiveModel::Validations::FormatValidator.new(options).validate(field)
      end
    end
  end
end
