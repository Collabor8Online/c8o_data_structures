require "rails_helper"
require_relative "field"

module DataStructures
  class Definition
    RSpec.describe SignatureField do
      it_behaves_like "a field"
    end
  end
end
