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

  def candidate_search_field_name
    contractor? ? :candidate_fields_cont : :pe_fields_cont
  end

  def navbar_search_url
    contractor? ? profile_candidates_path : profile_proposal_employees_path
  end
end
