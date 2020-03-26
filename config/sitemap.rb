SitemapGenerator::Sitemap.default_host = 'https://rostjob.com'
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  add login_path, priority: 1, changefreq: false
  add landing_for_contractor_path, priority: 1, changefreq: false
  add landing_for_customer_path, priority: 1, changefreq: false
  add new_user_password_path, priority: 1, changefreq: false
  add new_contractor_path, priority: 1, changefreq: false
  add new_customer_path, priority: 1, changefreq: false
  add contractor_info_path, priority: 1, changefreq: false
end
