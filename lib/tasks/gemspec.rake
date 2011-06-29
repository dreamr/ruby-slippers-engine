namespace :gem do
  begin
    require 'jeweler'
    Jeweler::Tasks.new do |gem|
      gem.name = "ruby_slippers"
      gem.summary = %Q{the smartest blog-engine in all of Oz}
      gem.description = %Q{A ruby and rack based blog engine for heroku}
      gem.email = "james@rubyloves.me"
      gem.homepage = "http://github.com/dreamr/ruby_slippers"
      gem.authors = ["dreamr", "cloudhead"]
      gem.add_development_dependency "riot"
      gem.add_dependency "builder"
      gem.add_dependency "rack"
      if RUBY_PLATFORM =~ /win32/
        gem.add_dependency "maruku"
      else
        gem.add_dependency "rdiscount"
      end
    end
    Jeweler::GemcutterTasks.new
  rescue LoadError
    puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
  end
end