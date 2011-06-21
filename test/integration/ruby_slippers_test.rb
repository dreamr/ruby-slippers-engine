require 'support/test_helper'
require 'date'

context RubySlippers::Engine do
  setup do
    @config = RubySlippers::Engine::Config.new(:markdown => true, :author => AUTHOR, :url => URL)
    @ruby_slippers = Rack::MockRequest.new(RubySlippers::Engine::App.new(@config))
    RubySlippers::Engine::Paths[:articles] = "test/fixtures/articles"
    RubySlippers::Engine::Paths[:pages] = "test/fixtures/pages"
    RubySlippers::Engine::Paths[:templates] = "test/fixtures/templates"
  end
  
  context "GET /" do
    setup { @ruby_slippers.get('/') }

    asserts("returns a 200")                { topic.status }.equals 200
    asserts("body is not empty")            { not topic.body.empty? }
    asserts("content type is set properly") { topic.content_type }.equals "text/html"
    should("include a couple of articles")   { topic.body }.includes_elements("#articles li", 2)
    should("include an archive")            { topic.body }.includes_elements("#archives li", 2)

    context "with no articles" do
      setup { Rack::MockRequest.new(RubySlippers::Engine::App.new(@config.merge(:ext => 'oxo'))).get('/') }

      asserts("body is not empty")          { not topic.body.empty? }
      asserts("returns a 200")              { topic.status }.equals 200
    end

    context "with a user-defined to_html" do
      setup do
        @config[:to_html] = lambda do |path, page, binding|
          ERB.new(File.read("#{path}/#{page}.rhtml")).result(binding)
        end
        @ruby_slippers.get('/')
      end

      asserts("returns a 200")                { topic.status }.equals 200
      asserts("body is not empty")            { not topic.body.empty? }
      asserts("content type is set properly") { topic.content_type }.equals "text/html"
      should("include a couple of article")   { topic.body }.includes_elements("#articles li", 2)
      should("include an archive")            { topic.body }.includes_elements("#archives li", 2)
      asserts("Etag header present")          { topic.headers.include? "ETag" }
      asserts("Etag header has a value")      { not topic.headers["ETag"].empty? }
    end
  end

  context "GET /about" do
    setup { @ruby_slippers.get('/about') }
    asserts("returns a 200")                { topic.status }.equals 200
    asserts("body is not empty")            { not topic.body.empty? }
  end

  context "GET to an unknown route with a custom error" do
    setup do
      @config[:error] = lambda {|code| "error: #{code}" }
      @ruby_slippers.get('/unknown')
    end

    should("returns a 404") { topic.status }.equals 404
    should("return the custom error") { topic.body }.equals "error: 404"
  end

  context "Request is invalid" do
    setup { @ruby_slippers.delete('/invalid') }
    should("returns a 400") { topic.status }.equals 400
  end

  context "GET /index?param=testparam (get parameter)" do
    setup { @ruby_slippers.get('/index?param=testparam')   }
    asserts("returns a 200")                { topic.status }.equals 200
    asserts("content type is set properly") { topic.content_type }.equals "text/html"
    asserts("contain the env variable")           { topic.body }.includes_html("p" => /env passed: true/)
    asserts("access the http get parameter")           { topic.body }.includes_html("p" => /request method type: GET/)
    asserts("access the http parameter name value pair")           { topic.body }.includes_html("p" => /request name value pair: param=testparam/)
  end
end
