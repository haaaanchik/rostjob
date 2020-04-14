class AddRatingToProductionSites < ActiveRecord::Migration[5.2]
  def up
    add_column :production_sites, :rating, :decimal, precision: 10, scale: 1, default: 0.0
    add_column :production_sites, :deal_counter, :integer, default: 0
    change_column :profiles, :rating, :decimal, precision: 10, scale: 1, default: 0.0
    add_column :profiles, :deal_counter, :integer, default: 0
    update_rating_and_dial_counter
  end

  def down
    change_column :profiles, :rating, :string
    remove_column :production_sites, :rating
    remove_column :profiles, :deal_counter
    remove_column :production_sites, :deal_counter
  end

  private


  def update_rating_and_dial_counter
    Profile.where(profile_type: 'customer').each do |profile|
      proposal_employees_paid = profile.customer_proposal_employees.paid.count
      proposal_employees_revoked = profile.customer_proposal_employees.revoked.count
      profile.update(deal_counter: proposal_employees_paid)
      profile.update(rating: calculate_rating(profile, proposal_employees_revoked))
    end

    Profile.where(profile_type: 'contractor').each do |profile|
      proposal_employees_paid = profile.proposal_employees.paid.count
      proposal_employees_revoked = profile.proposal_employees.revoked.count
      profile.update(deal_counter: proposal_employees_paid)
      profile.update(rating: calculate_rating(profile, proposal_employees_revoked))
    end

    ProductionSite.all.each do |pr_site|
      proposal_employees_paid = pr_site.proposal_employees.paid.count
      proposal_employees_revoked = pr_site.proposal_employees.revoked.count
      pr_site.update(deal_counter: proposal_employees_paid)
      pr_site.update(rating: calculate_rating(pr_site, proposal_employees_revoked))
    end
  end

  def calculate_rating(profile, revoked_count)
    return 0.0 if profile.deal_counter.zero? || revoked_count.zero?
    (profile.deal_counter/(profile.deal_counter + revoked_count).to_d) * 10
  rescue ZeroDivisionError
    0.0
  end
end
