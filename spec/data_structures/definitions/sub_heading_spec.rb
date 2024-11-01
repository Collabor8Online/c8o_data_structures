require "rails_helper"

module DataStructures
  class Definition
    RSpec.describe SubHeading do
      describe ".new" do
        it "sets the text" do
          expect(described_class.new(text: "Welcome to my blog").text).to eq "Welcome to my blog"
        end
      end

      describe "#text" do
        it "defaults to an empty string" do
          expect(described_class.new.text).to eq ""
        end
      end
    end
  end
end
