require 'yaml'
require 'date'
require 'erb'
require 'rack'
require 'digest'
require 'open-uri'

if RUBY_PLATFORM =~ /win32/
  require 'maruku'
  Markdown = Maruku
else
  require 'rdiscount'
end

require 'builder'

$:.unshift File.dirname(__FILE__)

require 'ext/ext'
require 'ruby_slippers/app'
require 'ruby_slippers/site'
require 'ruby_slippers/engine'
require 'ruby_slippers/config'
require 'ruby_slippers/template'
require 'ruby_slippers/context'
require 'ruby_slippers/article'
require 'ruby_slippers/archives'
require 'ruby_slippers/repo'