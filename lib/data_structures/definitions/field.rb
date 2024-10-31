module DataStructures
  module Definitions
    class Field
      include ActiveModel::Model
      include ActiveModel::Attributes
      attribute :caption, :string
      validates :caption, presence: true
      attribute :description, :string, default: ""
      attribute :required, :boolean, default: false

      def required? = required
    end
  end
end
