module RubySlippers
  module Engine
    module Template
      def to_html page, config, &blk
        path = ([:layout, :repo].include?(page) ? Paths[:templates] : Paths[:pages])
        config[:to_html].call(path, page, binding)
      end

      def markdown text
        if (options = @config[:markdown])
          Markdown.new(text.to_s.strip, *(options.eql?(true) ? [] : options)).to_html
        else
          text.strip
        end
      end

      def method_missing m, *args, &blk
        self.keys.include?(m) ? self[m] : super
      end

      def self.included obj
        obj.class_eval do
          define_method(obj.to_s.split('::').last.downcase) { self }
        end
      end
    end
  end
end
