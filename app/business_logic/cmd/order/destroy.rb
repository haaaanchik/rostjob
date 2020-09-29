module Cmd
  module Order
    class Destroy
      include Interactor

      delegate :profile, to: :context
      delegate :orders_ids, to: :context

      def call    
        context.fail! unless profile.orders.where(id: orders_ids).destroy_all
      end
    end
  end
end