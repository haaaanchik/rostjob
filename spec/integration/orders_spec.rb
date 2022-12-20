# frozen_string_literal: true

require 'rails_helper'

# reports
RSpec.describe 'Order' do
  describe "create via controller by a customer" do
    let(:customer) { create :customer }
    let(:profile) { customer.profile }
    let(:price_group) { create :price_group }
    let(:position) { create :position, price_group: price_group }
    let(:production_site) { create :production_site_without_orders, profile: profile }
    let(:city) { production_site.city }

    it "creates an order template" do
      sign_in customer

      expect(OrderTemplate.count).to eq 0
      expect(Order.count).to eq 0

      post "/profile/production_sites/#{production_site.id}/order_templates", params: {
        creation_step: 1,
        commit: "далее",
        redirecting_back: false,
        order_template: {
          position_id: position.id,
          position_search: "Сварщик на машинах контактной (прессовой) сварки",
          skill: "",
          housing: 1,
          food_nutrition: 1,
          shift_method: 1
        }
      }
      expect(OrderTemplate.count).to eq 1
      expect(Order.count).to eq 0

      order_template = OrderTemplate.last
      patch "/profile/production_sites/#{production_site.id}/order_templates/#{order_template.id}",
        params: {
          creation_step: 2,
          commit: "далее",
          redirecting_back: false,
          order_template: {
            position_id: position.id,
            city_id: city.id,
            salary: 999999,
            other_info: {
              hourly_payment: '',
              terms: 'условия'
            }
          }
      }
      expect(OrderTemplate.last.salary).to eq '999999'
      expect(Order.count).to eq 0

      patch "/profile/production_sites/#{production_site.id}/order_templates/#{order_template.id}",
        params: {
          creation_step: 3,
          order_template: {
            template_saved: true,
            contact_person: {
              name: 'Контактное лицо',
              phone: '+7(777)-777-77-77'
            },
            other_info: {
              remark: 'Кого вы хотите видеть в заявке',
              requirements: {
                aspirant: {
                  show: 1,
                  text: 'Рекрутируйте соискателя и доведите до него все требования и условия.'
                },
                customer: {
                  show: 1,
                  text: 'Согласуйте соискателя с контактным лицом в заявке.'
                },
                control_aspirant: {
                  show: 1,
                  text: 'Проконтролируйте приезд в согласованную дату. При необходимости скорректируйте дату приезда в системе.'
                },
                added_data: {
                  show: 1,
                  text: 'ФИО, телефон, регистрация, возраст'
                },
              }
            }
          }
        }
      expect(OrderTemplate.last.contact_person["name"]).to eq 'Контактное лицо'
      expect(Order.count).to eq 1
      order = Order.last
      expect(order.state).to eq "draft"
      expect(order.can_be_paid?).to eq true

      r = get "/profile/production_sites/#{production_site.id}/orders/#{order.id}/pre_publish"
      expect(r).to eq 200
      expect(order.reload.state).to eq "waiting_for_payment"
      expect do
        put "/profile/production_sites/#{production_site.id}/orders/#{order.id}/publish",
          params: {
            order: {
              number_of_employees: 1
            }
          }
      end.to change { order.reload.balance.amount }.by (-order.customer_total)
      expect(order.reload.state).to eq "moderation"
      expect(order.reload.published_at).to be_nil
      
      # admin staffer accepts an order
      Cmd::Order::ToPublished.call(order: order)
      expect(order.reload.state).to eq "published"
      expect(order.reload.published_at).not_to be_nil
    end
  end

  describe "admin edits an order" do
    let!(:staffer) { create :staffer, :admin, login: "admin", password: "admin" }
    let(:customer) { create :customer }
    let(:profile) { customer.profile }
    let(:price_group) { create :price_group }
    let(:position) { create :position, price_group: price_group }
    let(:production_site) { create :production_site_without_orders, profile: profile }
    let(:city) { production_site.city }
    let(:order) { create :order, state: "published", published_at: Date.today, number_of_employees: 1 }

    it "updates an order" do
      r = post "/admin/login", params: { login: "admin", password: "admin" }
      patch "/admin/orders/#{order.id}",
        params: {
          commit: 'Сохранить',
          order: {
            state: 'published',
            number_of_employees: 2,
            contact_person: {
              name: '9991',
              phone: '+7(777)-777-77-77'
            },
            skill: '',
            city_id: city.id,
            salary: 111111,
            contractor_price: 6000.0,
            food_nutrition: 0,
            housing: 0,
            shift_method: 0,
            advertising: 0,
            adv_text: '',
            other_info: {
              hourly_payment: '',
              terms: 'Обязанности: ...',
              remark: '',
              requirements: {
                aspirant: {
                  show: 1,
                  text: 'Рекрутируйте соискателя и доведите до него все требования и условия.'
                },
                customer: {
                  show: 1,
                  text: 'Согласуйте соискателя с контактным лицом в заявке.'
                },
                control_aspirant: {
                  show: 1,
                  text: 'Проконтролируйте приезд в согласованную дату. При необходимости скорректируйте дату приезда в системе.'
                },
                added_data: {
                  show: 1,
                  text: 'ФИО, телефон, регистрация, возраст'
                }
              }
            }
          }
      }

      expect(order.reload.number_of_employees).to eq 2
      expect(order.reload.published_at).not_to be_nil
    end
  end
end
