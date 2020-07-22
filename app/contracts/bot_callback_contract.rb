class BotCallbackContract < Dry::Validation::Contract
  json do
    required(:guid).filled(:string)
    required(:name).filled(:string)
    required(:phone).filled(:string)
  end
end
