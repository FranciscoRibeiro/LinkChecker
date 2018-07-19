require_relative 'links/parser'

class Links
  def initialize(url)
    @url = url
  end

  def run
    links = Parser.new(@url).run

    links.each do |l|
      response = HTTParty.get(l)

      if (response.code == 200)
        puts response.code.to_s.green + "\t" + l
      else
        puts response.code.to_s.red + "\t" + l
      end
    end
  end
end
