module DataStructures
  class Definition
    class DateField < Field
      attribute :default, :string, default: ""
      validate :default do |date_field|
        date_field.errors.add :default, :is_not_legal_date_default unless date_field.default == "today" || date_field.default.match?(/\A-?\d+[dwmy]\z/)
      end
    end
  end
end
