require "rails_helper"
require_relative "collection_of_definitions"

module DataStructures
  class Definition
    RSpec.describe Section do
      it_behaves_like "a collection of definitions", {}
    end
  end
end
