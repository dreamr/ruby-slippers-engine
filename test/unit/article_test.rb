require 'support/test_helper'

context RubySlippers::Engine::Article do
  setup do
    @config = RubySlippers::Engine::Config.new(:markdown => true, :author => AUTHOR, :url => URL)
    @config[:markdown] = true
    @config[:date] = lambda {|t| "the time is #{t.strftime("%Y/%m/%d %H:%M")}" }
    @config[:summary] = {:length => 50}
    @config[:tag_separator] = ", "
    RubySlippers::Engine::Site.new(@config)
  end
  
  context "article finders" do

    context "by_title(regex)" do
      
    end
    
    context "by_title(string)" do
      
    end
    
    context "limit(num)" do
      
    end
  end
  
  context "when the article body and summary are the same" do
    setup do
      RubySlippers::Engine::Article.new({
        :title => "Dorothy & The Wizard of Oz.",
        :body => "#Chapter I\nhello, *stranger*. ~"
      }, @config)
    end
    should("not end in ...") { topic.summary !~ /&hellip;<\/p>/ }
  end

  context "with the bare essentials" do
    setup do
      RubySlippers::Engine::Article.new({
        :title => "Dorothy & The Wizard of Oz.",
        :body => "#Chapter I\nhello, *stranger*."
      }, @config)
    end

    should("have a title") { topic.title }.equals "Dorothy & The Wizard of Oz."
    should("parse the body as markdown") { topic.body }.equals "<h1>Chapter I</h1>\n\n<p>hello, <em>stranger</em>.</p>\n"
    should("create an appropriate slug") { topic.slug }.equals "dorothy-and-the-wizard-of-oz"
    should("set the date") { topic.date }.equals "the time is #{Date.today.strftime("%Y/%m/%d %H:%M")}"
    should("create a summary") { topic.summary == topic.body }
    should("have an author")   { topic.author }.equals AUTHOR
    should("have a path") { topic.path }.equals Date.today.strftime("/%Y/%m/%d/dorothy-and-the-wizard-of-oz/")
    should("have a url")  { topic.url }.equals Date.today.strftime("#{URL}/%Y/%m/%d/dorothy-and-the-wizard-of-oz/")
  end

  context "with a user-defined summary" do
    setup do
      RubySlippers::Engine::Article.new({
        :title => "Dorothy & The Wizard of Oz.",
        :body => "Well,\nhello ~\n, *stranger*."
      }, @config.merge(:markdown => false, :summary => {:max => 150, :delim => /~\n/}))
    end

    should("split the article at the delimiter") { topic.summary }.equals "Well,\nhello"
    should("not have the delimiter in the body") { topic.body !~ /~/ }
  end

  context "with everything specified" do
    setup do
      RubySlippers::Engine::Article.new({
        :title  => "The Wizard of Oz",
        :body   => ("a little bit of text." * 5) + "\n" + "filler" * 10,
        :date   => "19/10/1976",
        :slug   => "wizard-of-oz",
        :author => "toetoe",
        :tags   => "wizards, oz",
        :image  => "ozma.png"
      }, @config)
    end

    should("parse the date")  { [topic[:date].month, topic[:date].year] }.equals [10, 1976]
    should("use the slug")    { topic.slug }.equals "wizard-of-oz"
    should("use the author")  { topic.author }.equals "toetoe"
    should("have tags")  { topic.tags }.equals "wizards, oz"
    should("have tag links")  { topic.tag_links }.equals "<a href=\"/tagged/wizards\">wizards</a>, <a href=\"/tagged/oz\">oz</a>"
    should("have an image")   { topic.image_src }.equals "/img/articles/1976/october/ozma.png"
    should("end in ...") { topic.summary =~ /&hellip;<\/p>/ }

    context "and long first paragraph" do
      should("create a valid summary") { topic.summary }.equals "<p>" + ("a little bit of text." * 5).chop + "&hellip;</p>\n"
    end

    context "and a short first paragraph" do
      setup do
        @config[:markdown] = false
        RubySlippers::Engine::Article.new({:body => "there ain't such thing as a free lunch\n" * 10}, @config)
      end

      should("create a valid summary") { topic.summary.size }.within 75..80
    end
  end

  context "in a subdirectory" do
    context "with implicit leading forward slash" do
      setup do
        conf = RubySlippers::Engine::Config.new({})
        conf.set(:prefix, "blog")
        RubySlippers::Engine::Article.new({
          :title => "Dorothy & The Wizard of Oz.",
          :body => "#Chapter I\nhello, *stranger*."
        }, conf)
      end

      should("be in the directory") { topic.path }.equals Date.today.strftime("/blog/%Y/%m/%d/dorothy-and-the-wizard-of-oz/")
    end

    context "with explicit leading forward slash" do
      setup do
        conf = RubySlippers::Engine::Config.new({})
        conf.set(:prefix, "/blog")
        RubySlippers::Engine::Article.new({
          :title => "Dorothy & The Wizard of Oz.",
          :body => "#Chapter I\nhello, *stranger*."
        }, conf)
      end

      should("be in the directory") { topic.path }.equals Date.today.strftime("/blog/%Y/%m/%d/dorothy-and-the-wizard-of-oz/")
    end

    context "with explicit trailing forward slash" do
      setup do
        conf = RubySlippers::Engine::Config.new({})
        conf.set(:prefix, "blog/")
        RubySlippers::Engine::Article.new({
          :title => "Dorothy & The Wizard of Oz.",
          :body => "#Chapter I\nhello, *stranger*."
        }, conf)
      end

      should("be in the directory") { topic.path }.equals Date.today.strftime("/blog/%Y/%m/%d/dorothy-and-the-wizard-of-oz/")
    end
  end


end