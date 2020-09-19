module Cmd
  module Order
    class Destroy
      include Interactor

      delegate :orders_ids, to: :context
      delegate :profile, to: :context

      def call    
        context.fail! unless profile.orders.where(id: orders_ids).destroy_all
      end
    end
  end
end