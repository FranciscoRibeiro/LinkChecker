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

        return all_links.uniq
    end

    def get_elems(elem)
        return @doc.css(elem)
    end

    def extract_links(elems, attr)
        all_elem_links = elems.map{ |e| e[attr]}.compact
        relatives, absolutes = all_elem_links.partition{ |link| is_relative?(link)}
        joined_relatives = relatives.map{ |rel_link| URI.join(@url, rel_link).to_s}
        return (joined_relatives << absolutes).flatten
    end

    def is_relative?(link)
        if(link.start_with?('http'))
            return false
        else
            return true
        end
    end
end
