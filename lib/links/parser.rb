require "httparty"
require "links/link_verifier"

class Parser
  ELEMENTS = { a: ["href"],
               img: ["src"],
               script: ["src"],
               frame: ["src"],
               iframe: ["src"],
               link: ["href"],
               source: %w[src srcset],
               track: ["src"] }.freeze

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def run
    ELEMENTS
      .flat_map do |elem, attr_list|
        attr_list.flat_map do |attr|
          extract_links(get_elems(elem), attr)
        end
      end
      .uniq
  end

  private

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
    relatives, absolutes = split_links(elems, attr)

    relatives
      .map { |rel_link| URI.join(url, rel_link).to_s }
      .append(absolutes)
      .flatten
      .select { |link| LinkVerifier.is_valid?(link) }
  end

  def split_links(elems, attr)
    elems
      .map { |e| e[attr] }
      .compact
      .partition { |link| LinkVerifier.is_relative?(link) }
  end
end
