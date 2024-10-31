require "rails_helper"
require_relative "../container"

module DataStructures
  module Definitions
    RSpec.describe Section do
      it_behaves_like "a container", {}
    end
  end
end
