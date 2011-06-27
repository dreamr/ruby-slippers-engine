require 'support/test_helper'
require 'date'

module RubySlippers::Engine
  context "Engine" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))
      Paths[:articles] = "test/fixtures/articles"
      Paths[:pages] = "test/fixtures/pages"
      Paths[:templates] = "test/fixtures/templates"
    end

    context "GET to a repo name" do
      setup do
        class Repo
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
        conf = Config.new({})
        conf.set(:summary, {:delim => /%/})
        conf
      end

      should("set summary[:delim] to /%/") { topic[:summary][:delim].source }.equals "%"
      should("leave the :max intact") { topic[:summary][:max] }.equals 150
    end

    context "using Config#set with a block" do
      setup do
        conf = Config.new({})
        conf.set(:to_html) {|path, p, _| path + p }
        conf
      end

      should("set the value to a proc") { topic[:to_html] }.respond_to :call
    end

    context "testing individual configuration parameters" do
      context "generate error pages" do
        setup do
          conf = Config.new({})
          conf.set(:error) {|code| "error code #{code}" }
          conf
        end

        should("create an error page") { topic[:error].call(400) }.equals "error code 400"
      end
    end
  end
end
