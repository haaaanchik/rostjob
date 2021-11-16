# frozen_string_literal: true

class TermOfUsesController < ApplicationController
  skip_before_action :auth_user, only: %i[industrial_download freelance_download]

  def index
    @term_of_uses = TermOfUses.new
  end

  def accept
    @term_of_uses = TermOfUses.new(term_of_uses_params)
  end

  private

  def term_of_uses_params
    params.require(:term_of_uses).permit(:accepted)
  end

end
