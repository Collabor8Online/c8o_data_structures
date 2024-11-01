module DataStructures
  class Definition
    class Template < Container
      attribute :name, :string
      validates :name, presence: true
      attribute :description, :string, default: ""
    end
  end
end
