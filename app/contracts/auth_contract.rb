class AuthContract < Dry::Validation::Contract
  params do
    required(:api_token).filled(:string)
  end
end
