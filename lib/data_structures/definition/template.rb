module DataStructures
  class Definition
    class Template < Collection
      attribute :name, :string
      validates :name, presence: true
      attribute :description, :string, default: ""

      def path_name = ""
    end
  end
end
