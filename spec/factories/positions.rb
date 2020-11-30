FactoryBot.define do
  factory :position do
    sequence :title do |n|
      "Position #{n}"
    end

    sequence :landing_title do |n|
      "landing_title#{n}"
    end

    sequence :slug do |n|
      "slug#{n}"
    end

    # after(:create) do |pos|
    #   price_group = create(:price_group)
    #   price_group.positions << pos
    # end
  end
end
