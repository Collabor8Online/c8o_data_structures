module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :_fields, as: :container, class_name: "DataStructures::Field", dependent: :destroy_async
      has_many :fields, -> { roots.order(:position) }, class_name: "DataStructures::Field", as: :container
      accepts_nested_attributes_for :fields
    end

    def fields= params
      fields = params.delete(:fields)
      update params
      fields.collect { |param| fields.find(param.delete(:_id)).fields = param }
    end

    def create_fields_for definition
      _fields.destroy_all
      definition.items.each_with_index do |item_definition, position|
        fields.find_by(position: position) || item_definition.create_field(position: position, container: self, definition: item_definition)
      end
    end
  end
end
