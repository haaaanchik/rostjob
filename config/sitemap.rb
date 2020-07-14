SitemapGenerator::Sitemap.default_host = 'https://rostjob.com'
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  add login_path, priority: 1, changefreq: false
  add freelance_path, priority: 1, changefreq: false
  add industrial_path, priority: 1, changefreq: false
  add new_user_password_path, priority: 1, changefreq: false
  add new_contractor_path, priority: 1, changefreq: false
  add new_customer_path, priority: 1, changefreq: false
  add contractor_info_path, priority: 1, changefreq: false
  add about_company_path, priority: 1, changefreq: false
  add contacts_path, priority: 1, changefreq: false
end
