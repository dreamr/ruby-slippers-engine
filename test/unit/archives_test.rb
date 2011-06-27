require 'support/test_helper'

module RubySlippers::Engine
  context Archives do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
    end
  
  end
end
