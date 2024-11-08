module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :_fields, as: :container, class_name: "DataStructures::Field", dependent: :destroy_async
      has_many :fields, -> { roots.order(:position) }, class_name: "DataStructures::Field", as: :container
      accepts_nested_attributes_for :fields
    end

    def find_field(field_name) = _fields.find_by field_name: field_name

    def create_fields_for definition
      return unless definition.respond_to? :items
      definition.items.each_with_index do |field_definition, position|
        existing_field = find_field field_definition.path_name
        existing_field.present? ? update_existing_field(existing_field, field_definition, position + 1) : create_field_from(field_definition, position + 1)
      end
    end

    def update_existing_field(field, field_definition, position) = field.update position: position, definition: field_definition

    def create_field_from(field_definition, position) = field_definition.create_field position: position, container: self
  end
end
