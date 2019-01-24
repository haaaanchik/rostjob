class CopyDatesFormEmployeeCvsToProposalEmployees < ActiveRecord::Migration[5.2]
  def change
    ProposalEmployee.hired.each do |pe|
      ecv = pe.employee_cv
      next unless ecv.respond_to?(:warranty_date) && ecv.respond_to?(:hiring_date) && ecv.respond_to?(:firing_date)
      pe.update_attribute(:warranty_date, ecv.warranty_date)
      pe.update_attribute(:hiring_date, ecv.hiring_date)
      pe.update_attribute(:firing_date, ecv.firing_date)
    end
  end
end
