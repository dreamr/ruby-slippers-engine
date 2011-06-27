require 'support/test_helper'

module RubySlippers::Engine
  context Archives do
    setup do
      @config = RubySlippers::Engine::Config.new(:markdown => true, :author => AUTHOR, :url => URL)
    end
  
  end
end
