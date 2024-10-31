module DataStructures
  module Definitions
    class Heading
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :text, :string, default: ""
    end
  end
end
