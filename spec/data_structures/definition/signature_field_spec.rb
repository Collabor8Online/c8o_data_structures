require "rails_helper"
require_relative "field_definition"

module DataStructures
  class Definition
    RSpec.describe SignatureField do
      it_behaves_like "a field definition"
    end
  end
end
