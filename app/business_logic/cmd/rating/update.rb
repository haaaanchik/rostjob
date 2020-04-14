module Cmd
  module Rating
    class Update
      include Interactor

      def call
        customer_rating = calculate(order_profile, customer_revoked_count)
        contractor_rating = calculate(candidate_profile, pr_emlp_revoked_count(candidate_profile))
        pr_site_rating = calculate(candidate_profile, pr_emlp_revoked_count(production_site))
        order_profile.update(rating: (customer_rating + 10)/2)
        candidate_profile.update(rating: (contractor_rating + 10)/2)
        production_site.update(rating: (pr_site_rating + 10)/2)
      end

      private

      def order_profile
        context.order_profile
      end

      def candidate
        context.candidate
      end

      def candidate_profile
        candidate.profile
      end

      def production_site
        candidate.order.production_site
      end

      def calculate(profile, revoked_count)
        return 0.0 if profile.deal_counter.zero? || revoked_count.zero?
        (((profile.deal_counter/(profile.deal_counter + revoked_count).to_d)*10)+10)/2
      rescue ZeroDivisionError
        5.0
      end

      def customer_revoked_count
        order_profile.customer_proposal_employees.revoked.count
      end

      def pr_emlp_revoked_count(item)
        item.proposal_employees.revoked.count
      end
    end
  end
end
