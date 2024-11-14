module DataStructures
  class Group < Field
    protected

    def generate_field_name = [parent&.field_name, position.to_s].compact.join("/")
  end
end
