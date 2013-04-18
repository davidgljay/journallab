xml.instruct!

xml.urlset :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  @papers.each do |p|
    xml.url do
      xml.loc p[:loc]
      xml.lastmod  p[:lastmod]
    end
  end
end
