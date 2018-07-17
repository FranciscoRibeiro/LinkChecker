require_relative 'links/parser'

class Links
  def initialize(url)
    @url = url
  end

  def run
    ary = Parser.new(@url).run

    ary.each do |a|
        response = HTTParty.get(a)
        if(response.code == 200)
            puts response.code.to_s.green + "\t" + a
        else
            puts response.code.to_s.red + "\t" + a
        end
    end
  end
end
