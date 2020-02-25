# frozen_string_literal: true

class Order
  module OrderTemplatable
    extend ActiveSupport::Concern

    included do
      attr_accessor :creation_step

      validates :position_id, :title, presence: true, if: -> { creation_step == 1 }
      validates :city, :salary, presence: true, if: -> { creation_step == 2 }
      validate  :check_for_emptiness

      def default_init
        {
          base_customer_price: 0,
          base_contractor_price: 0,
          customer_price: 0,
          contractor_price: 0,
          customer_total: 0,
          contractor_total: 0,
          warranty_period: 10,
          number_of_employees: 1,
          other_info: {
            remark: nil,
            terms: "<b>Обязанности:</b>\n<ul>\n<li></li>\n<li></li>\n</ul>\n<strong>Требования:</strong>\n
<ul>\n<li></li>\n<li></li>\n</ul>\n<strong>Условия:</strong>\n<ul>\n<li></li><li></li>\n</ul>",
          },
          contact_person: {
            name: nil,
            phone: nil
          },
          urgency_level: :middle,
          for_cis: false,
          advertising: false,
          adv_text: nil
        }
      end

      private

      def check_for_emptiness
        model_name = self.class.table_name.singularize
        case creation_step
        when 2
          errors.add(:other_info_terms.to_sym,
                     I18n.t('activerecord.errors.models.order_template.attributes.error.other_info.terms')) if other_info['terms'].blank?
        when 3
          errors.add(:contact_person_name.to_sym,
                     I18n.t("activerecord.errors.models.#{model_name}.attributes.error.contact_person.name")) if contact_person['name'].blank?
          errors.add(:contact_person_phone.to_sym,
                     I18n.t("activerecord.errors.models.#{model_name}.attributes.error.contact_person.phone")) if contact_person['phone'].blank?
          errors.add(:other_info_remark.to_sym,
                     I18n.t("activerecord.errors.models.#{model_name}.attributes.error.other_info.remark")) if other_info['remark'].blank?
        else
          true
        end
      end
    end
  end
end