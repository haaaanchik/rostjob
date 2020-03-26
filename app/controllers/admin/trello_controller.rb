class Admin::TrelloController < Admin::ApplicationController
  def index
    table_info
  end

  def export_xlsx
    table_info
    respond_to do |format|
      format.xlsx { render template: 'admin/trello/sale_rostjob', xlsx: 'Продажи RostJob' }
    end
  end

  private

  def table_info
    board = Trello::Board.find(Rails.application.credentials.trello[:board_id])
    @custom_field_options = board.custom_fields
    @columns = board.cards.group_by { |bd| bd.list.name }
  end
end
