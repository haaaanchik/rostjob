Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '442243626230816 ', 'bde1d45449f1526350e8c32e0bd19404'
  provider :vkontakte, '6463917', 'RuW7YDlobOT7IPeeO8lr'
end
