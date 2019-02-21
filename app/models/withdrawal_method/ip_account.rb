class WithdrawalMethod::IpAccount < WithdrawalMethod
  has_one :company, as: :companyable, dependent: :destroy

  def initialize(attrs = nil)
    defaults = {
      title: 'на расчетный счет ИП'
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  def withdraw(amount)
    puts "Withdraw #{amount} to ip account"
  end
end
