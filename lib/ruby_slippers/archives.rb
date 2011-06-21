module RubySlippers
  module Engine
    class Archives < Array
      include Template

      def initialize articles, config
        self.replace articles
        @config = config
      end

      def [] a
        a.is_a?(Range) ? self.class.new(self.slice(a) || [], @config) : super
      end

      def to_html
        super(:archives, @config)
      end
      alias :to_s to_html
      alias :archive archives
    end
  end
end
