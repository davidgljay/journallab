class Media < ActiveRecord::Base

  require 'rexml/document'
  require 'nokogiri'
  require 'open-uri'

  attr_accessible :category, :link, :user_id

  belongs_to :paper
  belongs_to :user

  before_validation :set_category
  before_save :set_embed

  validates :category, :presence => true



  #Examine text in link to determine whether it points to Youtube or Slideshare
  def set_category
    if link.nil?
      self.category = 'invalid'
    end
    if link.first(22).include?('youtube.com')
      self.category = 'youtube'
    elsif link.first(30).include?('slideshare.net')
      self.category = 'slideshare'
    else
      self.category = 'invalid'
    end
    self.category
   end

  # Determine the proper embed code and save it.
  # If youtube, just reformat the URL into an iframe.
  # If slideshare, ping the slideshare server to get the embed code.
  def set_embed
    if self.category == 'youtube'
      code = self.link.split('=')[1]
      self.embed = "<iframe width='700' height='400' src='http://www.youtube.com/embed/#{code}' frameborder='0' allowfullscreen></iframe>"
    elsif self.category == 'slideshare'
      url = 'http://www.slideshare.net/api/oembed/2?url=' + link + '&format=xml&maxwidth=700&maxheight=400'
      slideshare_iframe = open_xml(url).xpath("//html").children.first.text.split('<div').first
      code = slideshare_iframe.split('/embed_code/')[1].split('"').first
      self.embed = '<iframe src="http://www.slideshare.net/slideshow/embed_code/' + code + '" width="700" height="400" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px" allowfullscreen webkitallowfullscreen mozallowfullscreen> </iframe>'
    end
  end

  # Open URL as XML, used for pinging Slideshare to get an embed code
  def open_xml(url)
    doc = nil
    begin
      doc = Nokogiri::XML(open(url).read.strip)
    rescue Exception => ex
      attempts = attempts + 1
      retry if(attempts < 10)
    end
    doc
  end

end
