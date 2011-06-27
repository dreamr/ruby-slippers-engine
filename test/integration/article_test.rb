require 'support/test_helper'

module RubySlippers::Engine
  context Article do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))
      
      if File.expand_path("../../", __FILE__) =~ /engine/
        Paths[:articles]  = "test/fixtures/articles"
        Paths[:templates] = "test/fixtures/templates"
        Paths[:pages]     = "test/fixtures/pages"
      end
    end

    context "GET a single article" do
      setup { @ruby_slippers.get("/2010/05/17/the-wonderful-wizard-of-oz") }
      asserts("return a 200") { topic.status }.equals 200
      asserts("content type is set properly") { topic.content_type }.equals "text/html"
      should("contain the article") { topic.body }.includes_html("p" => /Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum./)
    end

    context "GET to the archive" do
      context "through a year" do
        setup { @ruby_slippers.get('/2011') }
        asserts("return a 200") { topic.status }.equals 200
        should("include the entries for that year") { topic.body }.includes_elements("li.article", 1)
      end

      context "through a year & month" do
        setup { @ruby_slippers.get('/2011/05') }
        asserts("return a 200")  { topic.status }.equals 200
        should("include the entries for that month") { topic.body }.includes_elements("li.article", 1)
        should("include the year & month") { topic.body }.includes_html("h1" => /2011\/05/)
      end

      context "through /archives" do
        setup { @ruby_slippers.get('/archives') }
      end
    end

    context "GET the tagged page" do 
      setup { @ruby_slippers.get('/tagged/wizard') }
      asserts("return a 200") { topic.status }.equals 200 
      asserts("body is not empty") {not topic.body.empty? }
      should("include only the entries for that tag") { topic.body }.includes_elements("li.article", 2)
      should("have access to @tag") { topic.body }.includes_html("h1" => /wizard/)
    end
  end
  
end
