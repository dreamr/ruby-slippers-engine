require 'support/test_helper'
module RubySlippers::Engine
  context App do
    setup do
      App.new.site
    end

    should("be the same as the singleton") {
      topic == App.site
    }
  end
end
