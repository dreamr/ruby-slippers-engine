require 'support/test_helper'

module RubySlippers::Engine
  context "Site" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
    end

    context "articles" do
      setup do
        Site.new(@config).articles
      end
      should("returns a size of 4") {
        topic.size
      }.equals 4

      should("returns a articles in array") {
        topic.class
      }.equals Array
    end

    context "sitemap(type)" do

    end

    context "index(type)" do

    end

    context "archives(filter)" do

    end

    context "article(route)" do

    end

    context "tagged(tag)" do

    end

    context "go(route, env, type)" do

    end

    context "privates" do
      context "http(code)" do

      end
    end
  end
end
