module ProposalsHelper
  def class_by_state(proposal)
    case proposal.state
    when 'sent'
     'badge-info'
    when 'accepted'
     'badge-success'
    when 'rejected'
     'badge-danger'
    end
  end
end
