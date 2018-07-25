class LinkVerifier
  def self.is_relative?(link)
    !link.start_with?("http")
  end

  def self.is_valid?(link)
    link =~ /\A#{URI::regexp}\z/
  end
end
