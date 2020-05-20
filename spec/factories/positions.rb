FactoryBot.define do
  factory :position do
    sequence :title do |n|
      "Position #{n}"
    end

    # after(:create) do |pos|
    #   price_group = create(:price_group)
    #   price_group.positions << pos
    # end
  end
end
