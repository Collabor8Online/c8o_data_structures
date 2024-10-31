module DataStructures
  module Definitions
    class SubHeading
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :text, :string, default: ""
    end
  end
end
