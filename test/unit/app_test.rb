require 'support/test_helper'
module RubySlippers::Engine
  context App do
    setup do
      RubySlippers::Engine::App.new.site
    end

    should("be the same as the singleton") {
      topic == RubySlippers::Engine::App.site
    }
  end
end
