require 'support/test_helper'

context RubySlippers::Engine::App do
  setup do
    RubySlippers::Engine::App.new.site
  end
  
  should("be the same as the singleton") {
    topic == RubySlippers::Engine::App.site
  }
end
