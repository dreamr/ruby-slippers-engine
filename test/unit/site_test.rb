require 'support/test_helper'

context RubySlippers::Engine::Site do
  setup do
    @config = RubySlippers::Engine::Config.new(:markdown => true, :author => AUTHOR, :url => URL)
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
  
  context "class methods" do
    context "self.articles(ext)" do
      context "privates" do
        
      end
    end
  end
  
  context "privates" do
    context "http(code)" do
      
    end
    
    context "articles" do
      
    end
  end
end