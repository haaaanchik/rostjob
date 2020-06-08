module Profile::OrdersHelper
  def orders_state_attributtes_for_select
    [['Все статусы',''],
      ['Ожидает оплаты', 'waiting_for_payment'],
      ['На модерации', 'moderation'],
      ['Открыта', 'published'],
      ['Отклонена', 'rejected'],
      ['Закрыта', 'completed']]
  end
end
