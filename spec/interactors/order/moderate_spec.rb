require 'rails_helper'

RSpec.feature 'Order::Moderated', type: :interactor do
  describe "lock" do
    let!(:order) { create(:order, :draft) }
    let!(:upd_price) { order.update(customer_total: 1_000_000) }
    let(:result) { Cmd::Order::Moderate.call(order: order, params: {number_of_employees: 50}) }

    it { expect(result).not_to be_a_success }
    it { expect(result.order.state).not_to eq('moderation') }
  end

  describe "pass" do
    let!(:order) { create(:order, :draft) }
    let!(:down_price) { order.update(customer_total: 1) }
    let(:result) { Cmd::Order::Moderate.call(order: order, params: {number_of_employees: 50}) }

    it { expect(result).to be_a_success }
    it { expect(result.order.state).to eq('moderation') }
  end

end
