FactoryBot.define do
  factory :position do
    sequence :title do |n|
      "Position #{n}"
    end

    landing_title { 'Test Landing Title' }
    sequence :slug do |n|
      "position-slug-#{n}"
    end

    # after(:create) do |pos|
    #   price_group = create(:price_group)
    #   price_group.positions << pos
    # end
  end
end
