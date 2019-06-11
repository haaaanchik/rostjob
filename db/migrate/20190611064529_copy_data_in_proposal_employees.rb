class CopyDataInProposalEmployees < ActiveRecord::Migration[5.2]
  def up
    ProposalEmployee.where(interview_date: nil).each do |pe|
      pe.update_attribute(:interview_date, pe.arrival_date)
    end
  end

  def down; end
end
