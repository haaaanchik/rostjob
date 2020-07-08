FactoryBot.define do
  factory :proposal_employee do
    state { 'inbox' }
    warranty_date { (Date.today - 2.month) }

    trait :interview do
      state { 'interview' }
      interview_date { Date.today }
    end

    trait :hired do
      state { 'hired' }
      hiring_date { (Date.today - 1.month) }
    end

    trait :approved do
      state { 'approved' }
      hiring_date { (Date.today - 1.month)}
    end

    trait :paid do
      state { 'paid' }
      payment_date { Date.today }
    end

    ## Nested message
    trait :disputed do
      state { 'disputed' }
      interview_date { Date.today }

      # after(:create) do |pr_empl|
      #   create(:incident, user: pr_empl.order.profile.user, waiting: 'contractor',
      #           proposal_employee: pr_empl)
      # end
    end

    before(:create) do |pr_empl|
      order = create(:order)
      pr_empl.order = order
      contractor = create(:contractor)
      pr_empl.profile = contractor.profile
      pr_empl.employee_cv = create(:employee_cv, profile: contractor.profile)
    end
  end
end
