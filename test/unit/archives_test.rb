require 'support/test_helper'

context RubySlippers::Engine::Archives do
  setup do
    @config = RubySlippers::Engine::Config.new(:markdown => true, :author => AUTHOR, :url => URL)
  end
  
end