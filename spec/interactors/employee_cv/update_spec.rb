require 'rails_helper'

RSpec.feature 'EmployeeCv::Update', type: :interactor do
  describe 'check write logs by contractor' do
    let(:contractor) { create(:contractor) }
    let(:employee_cv) { create(:employee_cv, profile: contractor.profile) }
    let!(:result) do
      Cmd::EmployeeCv::Update.call(user: contractor,
                                   employee_cv: employee_cv,
                                   params: { name: 'Обновлённое новое имя', phone_number: '79789999999'})
    end

    it { expect(UserActionLog.last.action).to include('Было изменено значение полного имени') }
    it { expect(UserActionLog.last.action).to include('Было изменено значение номер телефона') }
  end

  describe 'check write logs by admin' do
    let(:staffer) { create(:staffer, :admin)}
    let(:contractor) { create(:contractor) }
    let(:employee_cv) { create(:employee_cv, profile: contractor.profile) }
    let!(:result) do
      Cmd::EmployeeCv::Update.call(user: staffer,
                                   employee_cv: employee_cv,
                                   params: { name: 'Обновлённое новое имя', phone_number: '79789999999'})
    end

    it { expect(result).to be_a_success }
  end
end
