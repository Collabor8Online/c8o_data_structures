module DataStructures
  class Template
    include ActiveModel::API
    include ActiveModel::Attributes

    attribute :name
    validates :name, presence: true
    attribute :description
    attribute :items, default: [], type: Array
  end
end
