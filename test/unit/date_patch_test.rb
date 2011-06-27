require 'support/test_helper'

module RubySlippers::Engine
  context "RubySlippers" do
    context "extends Ruby lib date" do
      should("respond to iso8601") { Date.today }.respond_to?(:iso8601)
    end
  end
end

