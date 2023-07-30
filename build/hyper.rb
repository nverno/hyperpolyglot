require 'httparty'
require 'nokogiri'

module Hyper
  DOM = "https://hyperpolyglot.org".freeze
  @@index = nil
  @@pages = nil

  def self.parse_index
    index = Nokogiri::HTML(HTTParty.get(DOM).body)
    tables = index.xpath("//table").collect { |x| x }

    dat = {}
    tables.each do |item|
      item.css('td a').each do |x|
        href = x['href']
        x.content.gsub(/[\t\n]/, ' ').downcase.split(', ').each do |lang|
          dat[lang] = href
        end
      end
    end
    @@index = dat
    @@pages = {}
    nil
  end

  def self.parse_page path
    page = Nokogiri::HTML(HTTParty.get(DOM + path).body)
    hrefs = page.at_xpath('//p').next.next

    # some pages have two sheets, one of which links to different page
    hrefs = hrefs.next if /^\// =~ hrefs.css('a').first['href']

    # main sections
    h = hrefs.xpath('a').each_with_object({}) do |x, h|
      tag = x['href'][1..-1]
      h[tag] = {}
      h[tag][tag] = x.content
    end

    # add nodes for subsections
    h.each do |k, _v|
      section = page.at_css("##{k}").at_xpath("ancestor::tr").next
      while !(section.nil? || h.key?(section.xpath("th/a/@id").text))
        unless section.xpath('td').empty?
          tmp = section.xpath('td[1]/a')
          h[k][tmp.xpath('@id').text] = tmp.text if !tmp.nil?
        end
        section = section.next
      end
    end
    @@pages[path] = h
    nil
  end

  def self.get_index
    @@index.keys
  end

  def self.get_sections path
    @@pages[path].keys
  end

  def self.get_ids path, section
    @@pages[path][section].keys
  end

  def self.get_uri path, id
    DOM + path + '#' + id
  end

  def self.lookup(page = nil, section = nil, id = nil)
    parse_index if @@index.nil?
    if page.nil?
      get_index
    else
      path = @@index[page]
      return nil if path.nil?

      parse_page path if @@pages[path].nil?
      if section.nil? && id.nil?
        get_sections path
      elsif id.nil?
        ids = get_ids(path, section).filter { |x| !x.empty? }
        return get_uri(path, ids[0]) if ids.length == 1 rescue nil

        ids
      else
        get_uri(path, id) rescue nil
      end
    end
  end
end

# Hyper.lookup "python", "functions"
