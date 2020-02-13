module EmailHelper
  def logo_image
    attachments.inline['rost_job_logo.png'] = File.read("#{Rails.root}/app/assets/images/rost_job_logo.png")
    link_to root_url do
      image_tag(attachments['rost_job_logo.png'].url)
    end
  end
end