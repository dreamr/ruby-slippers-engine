module RubySlippers
  module Engine
    Paths = {
      :templates  => "templates",
      :pages      => "templates/pages",
      :articles   => "articles"
    } unless defined?(Paths)

    def self.gem_root
      File.expand_path("../../", __FILE__)
    end

    def self.env
      ENV['RACK_ENV'] || 'production'
    end

    def self.env= env
      ENV['RACK_ENV'] = env
    end
  end
end
