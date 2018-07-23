require_relative 'links/parser'

class Links

  attr_reader :url, :parser

  def initialize(url)
    @url = url
    @parser = Parser.new(url)
  end

  def run
    links = parser.run
    
    responses = Enumerator.new do |enum| 

      links.each do |l|
        response = HTTParty.get(l)

        enum << {code: response.code, link: l}
      end
    end

    responses
  end
end
