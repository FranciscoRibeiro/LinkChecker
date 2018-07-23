require 'httparty'

class Parser

  @@elements = { a: ['href'],
                img: ['src'],
                script: ['src'],
                frame: ['src'],
                iframe: ['src'],
                link: ['href'],
                source: ['src', 'srcset'],
                track: ['src'] }

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def run
    @@elements
      .flat_map { |elem, attr_list| attr_list.flat_map { |attr| extract_links(get_elems(elem), attr) } }
      .uniq
  end

  def doc
    @doc ||= get_html
  end

  def get_html
    Nokogiri::HTML(HTTParty.get(url))
  end

  def get_elems(elem)
    doc.css(elem)
  end

  def extract_links(elems, attr)
    relatives, absolutes = elems
                           .map { |e| e[attr] }
                           .compact
                           .partition { |link| is_relative?(link) }

    relatives
      .map { |rel_link| URI.join(url, rel_link).to_s }
      .append(absolutes)
      .flatten
      .select { |link| is_valid?(link) }
  end

  def is_relative?(link)
    !link.start_with?('http')
  end

  def is_valid?(link)
    link =~ /\A#{URI::regexp}\z/
  end
end
