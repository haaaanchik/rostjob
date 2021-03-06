FactoryBot.define do
  factory :withdrawal_method do
    trait :private_acc do
      title { 'на счет физического лица' }
      type { 'WithdrawalMethod::PrivatePersonAccount' }
    end

    trait :ip_account do
      title { 'на расчетный счет ИП' }
      type { 'WithdrawalMethod::IpAccount' }
    end

    after(:create) do |widthrawal|
      create(:contractor_company, companyable: widthrawal)
    end
  end
end
