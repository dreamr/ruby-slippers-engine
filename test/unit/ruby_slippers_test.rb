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
  
  context "GET to a repo name" do
    setup do
      class RubySlippers::Engine::Repo
        def readme() "#{self[:name]}'s README" end
      end
    end

    context "when the repo is in the :repos array" do
      setup do
        @config[:github] = {:user => "dreamr", :repos => ['repo']}
        @ruby_slippers.get('/repo')
      end
      should("return repo's README") { topic.body }.includes("repo's README")
    end

    context "when the repo is not in the :repos array" do
      setup do
        @config[:github] = {:user => "dreamr", :repos => []}
        @ruby_slippers.get('/repo')
      end
      should("return a 404") { topic.status }.equals 404
    end
  end

  context "using Config#set with a hash" do
    setup do
      conf = RubySlippers::Engine::Config.new({})
      conf.set(:summary, {:delim => /%/})
      conf
    end

    should("set summary[:delim] to /%/") { topic[:summary][:delim].source }.equals "%"
    should("leave the :max intact") { topic[:summary][:max] }.equals 150
  end

  context "using Config#set with a block" do
    setup do
      conf = RubySlippers::Engine::Config.new({})
      conf.set(:to_html) {|path, p, _| path + p }
      conf
    end

    should("set the value to a proc") { topic[:to_html] }.respond_to :call
  end

  context "testing individual configuration parameters" do
    context "generate error pages" do
      setup do
        conf = RubySlippers::Engine::Config.new({})
        conf.set(:error) {|code| "error code #{code}" }
        conf
      end

      should("create an error page") { topic[:error].call(400) }.equals "error code 400"
    end
  end

  context "extensions to the core Ruby library" do
    should("respond to iso8601") { Date.today }.respond_to?(:iso8601)
  end
end


