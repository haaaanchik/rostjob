module Cmd
  module Order
    class CalculateUrgency
      include Interactor

      def call
        context.urgency = urgency
      end

      private

      def urgency
        base_contractor_price = params[:base_contractor_price].to_i
        contractor_price = params[:contractor_price].to_i
        if contractor_price > base_contractor_price
          :high
        elsif contractor_price < base_contractor_price
          :low
        else
          :middle
        end
      end

      def params
        context.params
      end
    end
  end
end
