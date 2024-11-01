module DataStructures
  class Definition
    class Field < Definition
      attribute :caption, :string
      validates :caption, presence: true
      attribute :description, :string, default: ""
      attribute :required, :boolean, default: false

      def required? = required
    end
  end
end
