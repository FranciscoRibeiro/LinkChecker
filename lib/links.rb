require "links/parser"

class Links
  attr_reader :url, :parser

  def initialize(url, parser=nil)
    @url = url
    @parser = parser || Parser.new(url)
  end

  def run
    links = parser.run

    links.lazy.map do |l|
      response = HTTParty.get(l)

      { code: response.code, link: l }
    end
  end
end
