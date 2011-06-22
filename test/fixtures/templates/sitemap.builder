xml.instruct!
xml.urlset("xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9") do

  xml.url do 
    xml.loc @config[:site_url]
    xml.changefreq "weekly"
  end

  xml.url do 
    xml.loc @config[:site_url] + '/about'
    xml.changefreq "weekly"
  end

  xml.url do 
    xml.loc @config[:site_url] + '/archives'
    xml.changefreq "weekly"
  end

  articles.each do |article|
    xml.url do
      xml.loc @config[:site_url] + article.path
      xml.changefreq "weekly"
    end
  end
end