require 'httparty'

class Parser

  def initialize(url)
    @elements = { a: ['href'],
                  img: ['src'],
                  script: ['src'],
                  frame: ['src'],
                  iframe: ['src'],
                  link: ['href'],
                  source: ['src', 'srcset'],
                  track: ['src'] }

    @url = url
  end

  def run
    all_links = []
    @doc = Nokogiri::HTML(HTTParty.get(@url))

    @elements.each do |elem, attr_list|
      elems = get_elems(elem)

      attr_list.each do |attr|
        links = extract_links(elems, attr)
        all_links = (all_links << links).flatten
      end
    end

    all_links.uniq
  end

  def get_elems(elem)
    @doc.css(elem)
  end

  def extract_links(elems, attr)
    relatives, absolutes = elems
                           .map { |e| e[attr] }
                           .compact
                           .partition { |link| is_relative?(link) }

    relatives
      .map { |rel_link| URI.join(@url, rel_link).to_s }
      .append(absolutes)
      .flatten
      .select { |link| is_valid?(link) }
  end

  def is_relative?(link)
    !link.start_with?('http')
  end

  def is_valid?(link)
    # p link
    link =~ /\A#{URI::regexp}\z/
  end
end
