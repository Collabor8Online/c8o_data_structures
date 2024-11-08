module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :_fields, as: :container, class_name: "DataStructures::Field", dependent: :destroy_async
      has_many :fields, -> { roots.order(:position) }, class_name: "DataStructures::Field", as: :container
      accepts_nested_attributes_for :fields
    end

    def create_fields_for definition
      _fields.destroy_all
      definition.items.each_with_index do |item_definition, position|
        fields.find_by(position: position) || item_definition.create_field(position: position, container: self, definition: item_definition)
      end
    end

    def find_field path
      _fields.find_by field_name: path
    end
  end
end
