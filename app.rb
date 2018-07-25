require "rubygems"
require "bundler"
require "links"

Bundler.require(:default)

class App
  def colorize_code(code)
    if (200..299).cover?(code)
      code.to_s.green
    else
      code.to_s.red
    end
  end

  def print_response(response)
    puts colorize_code(response[:code]) + "\t" + response[:link]
  end

  def run(arg)
    responses = Links.new(arg).run
    
    responses.each { |r| print_response(r) }
  end
end

App.new.run(ARGV[0]) if __FILE__ == $0
