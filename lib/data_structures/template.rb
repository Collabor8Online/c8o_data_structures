require_relative "definitions/container"

module DataStructures
  class Template < Definitions::Container
    attribute :name, :string
    validates :name, presence: true
    attribute :description, :string, default: ""
  end
end
