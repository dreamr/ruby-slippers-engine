require 'support/test_helper'

context RubySlippers::Engine::Article do
  setup do
    @config = RubySlippers::Engine::Config.new(:markdown => true, :author => AUTHOR, :url => URL)
    @ruby_slippers = Rack::MockRequest.new(RubySlippers::Engine::App.new(@config))
    RubySlippers::Engine::Paths[:articles] = "test/fixtures/articles"
    RubySlippers::Engine::Paths[:pages] = "test/fixtures/pages"
    RubySlippers::Engine::Paths[:templates] = "test/fixtures/templates"
  end
  
  context "GET /index.xml (atom feed)" do
    setup { @ruby_slippers.get('/index.xml') }
    asserts("content type is set properly") { topic.content_type }.equals "application/xml"
    asserts("body should be valid xml")     { topic.body }.includes_html("feed > entry" => /.+/)
    asserts("summary shouldn't be empty")   { topic.body }.includes_html("summary" => /.{10,}/)
  end
  
end