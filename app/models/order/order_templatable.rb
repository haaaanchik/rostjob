# frozen_string_literal: true

class Order
  module OrderTemplatable
    extend ActiveSupport::Concern

    included do
      attr_accessor :creation_step

      validates :position_id, :title, presence: true, if: -> { creation_step == 1 }
      validates :city_id, :salary, presence: true, if: -> { creation_step == 2 }
      validate  :check_for_emptiness

      ASPIRANT_TEXT = 'Рекрутируйте соискателя и доведите до него все требования и условия.'
      CUSTOMER_TEXT = 'Согласуйте соискателя с контактным лицом в заявке.'
      CONTRACTOR_ASPIRANT_TEXT = 'Проконтролируйте приезд в согласованную дату. При необходимости скорректируйте дату приезда в системе.'

      def default_init
        {
          base_customer_price: 0,
          base_contractor_price: 0,
          customer_price: 0,
          contractor_price: 0,
          customer_total: 0,
          contractor_total: 0,
          number_of_employees: 1,
          other_info: {
            remark: nil,
            terms: '<p class"subtitle">Обязанности:</p><span><ul><li></li><li></li></ul></span>
<p class"subtitle">Требования:</p><span><ul><li></li><li></li></ul></span>
<p class"subtitle">Условия:</p><span><ul><li></li><li></li></ul></span>',
            requirements: {
              aspirant: {
                show: '1',
                text: self.class::ASPIRANT_TEXT
              },
              customer: {
                show: '1',
                text: self.class::CUSTOMER_TEXT
              },
              added_data: {
                show: '1',
                text: 'ФИО, телефон, регистрация, возраст'
              },
              control_aspirant: {
                show: '1',
                text: self.class::CONTRACTOR_ASPIRANT_TEXT
              }
            }
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

      def added_data?
        other_info['requirements']['added_data']['text'].present?
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
        else
          true
        end
      end
    end
  end
end
