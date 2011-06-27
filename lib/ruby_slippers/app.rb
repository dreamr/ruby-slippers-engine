module RubySlippers
  module Engine
    class App
      attr_reader :config, :site
      
      @@site = nil

      def initialize config = {}, &blk
        @config = config.is_a?(Config) ? config : Config.new(config)
        @config.instance_eval(&blk) if block_given?
        @site ||= @@site = RubySlippers::Engine::Site.new(@config)
      end
      
      def self.site
        @@site
      end

      def call env
        @request  = Rack::Request.new env
        @response = Rack::Response.new

        return [400, {}, []] unless @request.get?

        path, mime = @request.path_info.split('.')
        route = (path || '/').split('/').reject {|i| i.empty? }

        response = @site.go(route, env, *(mime ? mime : []))

        @response.body = [response[:body]]
        @response['Content-Length'] = response[:body].length.to_s unless response[:body].empty?
        @response['Content-Type']   = Rack::Mime.mime_type(".#{response[:type]}")

        # Set http cache headers
        @response['Cache-Control'] = if RubySlippers::Engine.env == 'production'
          "public, max-age=#{@config[:cache]}"
        else
          "no-cache, must-revalidate"
        end

        @response['ETag'] = %("#{Digest::SHA1.hexdigest(response[:body])}")

        @response.status = response[:status]
        @response.finish
      end
    end
  end
end
