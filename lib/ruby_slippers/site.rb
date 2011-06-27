module RubySlippers
  module Engine
    class Site
      def initialize config
        @config = config
      end

      def [] *args
        @config[*args]
      end

      def []= key, value
        @config.set key, value
      end
      
      def articles
        self.class.articles self[:ext]
      end
      
      def sitemap type = :xml
        articles = type == :html ? self.articles.reverse : self.articles
   {:articles => articles.map do |article|
          Article.new article, @config
        end}.merge archives
      end

      def index type = :html
        articles = type == :html ? self.articles.reverse : self.articles
   {:articles => articles.map do |article|
          Article.new article, @config
        end}.merge archives
      end

      def archives filter = ""
        entries = ! self.articles.empty??
          self.articles.select do |a|
            filter !~ /^\d{4}/ || File.basename(a) =~ /^#{filter}/
          end.reverse.map do |article|
            Article.new article, @config
          end : []

        return :archives => Archives.new(entries, @config)
      end

      def article route
        Article.new("#{Paths[:articles]}/#{route.join('-')}.#{self[:ext]}", @config).load
      end

      def tagged tag
        articles = self.articles.collect do |article|
          Article.new article, @config
        end.select do |article|
          article[:tags].index(tag.humanize.downcase) if article[:tags]
        end

   {:articles => articles, :tagged => tag}
      end

      def /
        self[:root]
      end

      def go route, env = {}, type = :html
        route << self./ if route.empty?
        type, path = type =~ /html|xml|json/ ? type.to_sym : :html, route.join('/')
        context = lambda do |data, page|
          Context.new(data, @config, path, env).render(page, type)
        end

        body, status = if Context.new.respond_to?(:"to_#{type}")
          if route.first =~ /\d{4}/
            case route.size
              when 1..3
                context[archives(route * '-'), :archives]
              when 4
                context[article(route), :article]
              else http 400
            end
          elsif route.first == "tagged"
            context[tagged(route.last), :tagged]
          elsif respond_to?(path)
            context[send(path, type), path.to_sym]
          elsif (repo = @config[:github][:repos].grep(/#{path}/).first) &&
                !@config[:github][:user].empty?
            context[Repo.new(repo, @config), :repo]
          else
            context[{}, path.to_sym]
          end
        else
          http 400
        end

      rescue NoMethodError, Errno::ENOENT => e
        return :body => http(404).first, :type => :html, :status => 404
      else
        return :body => body || "", :type => type, :status => status || 200
      end

    protected

      def http code
        [@config[:error].call(code), code]
      end

      def self.articles ext
        Dir["#{Paths[:articles]}/*.#{ext}"].sort_by {|entry| File.basename(entry) }
      end
    end
  end
end
