class FixStatesEmployeeCvs < ActiveRecord::Migration[5.2]
  def change
    EmployeeCv.where(state: 'applyed').each { |i| i.update_attribute(:state, 'sent') }
    EmployeeCv.where(state: 'hired').each { |i| i.update_attribute(:state, 'sent') }
  end
end
