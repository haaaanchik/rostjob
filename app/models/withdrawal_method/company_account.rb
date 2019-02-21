class WithdrawalMethod::CompanyAccount < WithdrawalMethod
  def initialize(attrs = nil)
    defaults = {
      title: 'на расчетный счет юридического лица'
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  def withdraw(amount)
    puts "Withdraw #{amount} to company account"
  end
end
