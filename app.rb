require 'rubygems'
require 'bundler'
require_relative 'lib/links'

Bundler.require(:default)

def colorize_code(code)
  if (200..299).include?(code)
    code.to_s.green
  else
    code.to_s.red
  end
end

def print_response(response)
  puts colorize_code(response[:code]) + "\t" + response[:link]
end

if __FILE__ == $0
  responses = Links.new(ARGV[0]).run
  
  responses.each { |r| print_response(r) }
end
