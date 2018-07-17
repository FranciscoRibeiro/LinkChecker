require 'rubygems'
require 'bundler'
require_relative 'lib/links'

Bundler.require(:default)

if __FILE__ == $0
  Links.new(ARGV[0]).run
end
