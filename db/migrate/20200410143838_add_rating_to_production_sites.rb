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
      rating = calculation_for_others(profile, proposal_employees_revoked)
      profile.update(rating: (rating + 10)/2)
    end

    Profile.where(profile_type: 'contractor').each do |profile|
      proposal_employees_paid = profile.proposal_employees.paid.count
      proposal_employees_revoked = profile.proposal_employees.revoked.count
      profile.update(deal_counter: proposal_employees_paid)
      rating = calculation_contractor(profile, proposal_employees_revoked)
      profile.update(rating: rating)
    end

    ProductionSite.all.each do |pr_site|
      proposal_employees_paid = pr_site.proposal_employees.paid.count
      proposal_employees_revoked = pr_site.proposal_employees.revoked.count
      pr_site.update(deal_counter: proposal_employees_paid)
      rating = calculation_for_others(pr_site, proposal_employees_revoked)
      pr_site.update(rating:  (rating + 10)/2)
    end
  end

  def calculation_contractor(profile, revoked_count)
    return 0.0 if profile.deal_counter.zero? || revoked_count.zero?
    calculation(profile.deal_counter, revoked_count)
  end

  def calculation_for_others(profile, revoked_count)
    return 5.0 if profile.deal_counter.zero? || revoked_count.zero?
    calculation(profile.deal_counter, revoked_count)
  end

  def calculation(deal_counter, revoked_count)
    (deal_counter/(deal_counter + revoked_count).to_d) * 10
  end
end
