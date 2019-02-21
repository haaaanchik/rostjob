module Cmd
  module Profile
    module Balance
      class Withdrawal
        include Interactor

        def call
          amount = context.amount
          balance_amount = context.profile.balance.amount
          context.fail! if amount.to_i > balance_amount
          WithdrawalJob.perform_later(context.withdrawal_method_id, amount)
        end
      end
    end
  end
end
