module RubySlippers
  module Engine
    class Repo < Hash
      include Template

      README = "https://github.com/%s/%s/raw/master/README.%s"

      def initialize name, config
        self[:name], @config = name, config
      end

      def readme
        markdown open(README %
          [@config[:github][:user], self[:name], @config[:github][:ext]]).read
      rescue Timeout::Error, OpenURI::HTTPError => e
        "This page isn't available."
      end
      alias :content readme
    end
  end
end
