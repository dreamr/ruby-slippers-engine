class RubySlippers::Engine::Config < Hash
  Defaults = {
    :author => ENV['USER'],                               # blog author
    :title => Dir.pwd.split('/').last,                    # site title
    :root => "index",                                     # site index
    :url => "http://127.0.0.1",                           # root URL of the site
    :prefix => "",                                        # common path prefix for the blog
    :date => lambda {|now| now.strftime("%d/%m/%Y") },    # date function
    :markdown => :smart,                                  # use markdown
    :disqus => false,                                     # disqus name
    :summary => {:max => 150, :delim => /~\n/},           # length of summary and delimiter
    :ext => 'txt',                                        # extension for articles
    :cache => 28800,                                      # cache duration (seconds)
    :tag_separator => ', ',                               # tag separator for articles
    :github => {:user => "dreamr", :repos => [], :ext => 'md'}, # Github username and list of repos
    :to_html => lambda {|path, page, ctx|                 # returns an html, from a path & context
      ERB.new(File.read("#{path}/#{page}.html.erb")).result(ctx)
    },
    :error => lambda {|code|                              # The HTML for your error page
      "<font style='font-size:300%'>A large house has landed on you. You cannot continue because you are dead. <a href='/'>try again</a> (#{code})</font>"
    }
  }
  def initialize obj
    self.update Defaults
    self.update obj
  end

  def set key, val = nil, &blk
    if val.is_a? Hash
      self[key].update val
    else
      self[key] = block_given?? blk : val
    end
  end
end
