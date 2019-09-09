class BotCallbackContract < Dry::Validation::Contract
  json do
    required(:guid).filled(:string)
    required(:candidate_id).filled(:string)
    required(:call_data).filled
  end
end
