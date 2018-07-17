require_relative 'links/parser'

class Links
  def initialize(url)
    @url = url
  end

  def run
    ary = Parser.new(@url).run
    p ary

    ary.each do |a|
      # ...
    end
  end
end
