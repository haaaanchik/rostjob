module ProposalEmployeesHelper
  def url_form_canidates
    return profile_candidates_path if current_user.profile.customer?

    profile_proposal_employees_path
  end

  def candidate_search_fields
    return :candidate_fields_cont if current_user.profile.customer?

    :pe_fields_cont
  end
end