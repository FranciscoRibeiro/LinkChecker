require 'httparty'

class Parser

    def initialize(url)
        @elements = {a: ["href"],
                img: ["src"],
                script: ["src"],
                frame: ["src"],
                iframe: ["src"],
                link: ["href"],
                source: ["src", "srcset"],
                track: ["src"] }

        @url = url
    end

    def run
        all_links = Array.new
        @doc = Nokogiri::HTML(HTTParty.get(@url))

        @elements.each do |elem, attr_list|
            elems = get_elems(elem)

            attr_list.each do |attr|
                links = extract_links(elems, attr)
                all_links = (all_links << links).flatten
            end
        end

        return all_links
    end

    def get_elems(elem)
        return @doc.css(elem)
    end

    def extract_links(elems, attr)
        elems.map{ |e|  e[attr]}.compact
    end
end
