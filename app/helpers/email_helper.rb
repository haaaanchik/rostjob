module EmailHelper
  def logo_image
    attachments.inline['logo_rost_job_final.png'] = File.read("#{Rails.root}/app/assets/images/logo_rost_job_final.png")
    link_to root_url do
      image_tag(attachments['logo_rost_job_final.png'].url)
    end
  end

  def count_proposal_employee_by_order(proposal_employee)
    result = {}

    proposal_employee.each do |prop|
      if result.key?(prop.order_id)
        result[prop.order_id] += 1
      else
        result[prop.order_id] = 1
      end
    end

    result
  end

  def count_interview_by_days(prop_emps)
    result = { today_interviews: 0, before_interviews: 0 }

    prop_emps.each do |prop|
      if prop.interview_date == DateTime.now.beginning_of_day
        result[:today_interviews] += 1
      else
        result[:before_interviews] += 1
      end
    end

    result
  end
end