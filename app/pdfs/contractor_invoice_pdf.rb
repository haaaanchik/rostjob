class ContractorInvoicePdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(invoice, view)
    super(page_size: 'A4', page_layout: :portrait, margin: 10.mm)
    @invoice = invoice
    @seller = invoice.seller
    @buyer = invoice.buyer
    @goods = invoice.goods
    @total = invoice.amount
    @profile = invoice.profile
    @total_price = 0
    @view = view
    font_families.update(
      'Arial' => {
        normal: Rails.root.join('public', 'font', 'arial', 'ArialMT.ttf'),
        bold: Rails.root.join('public', 'font', 'arial', 'Arial-BoldMT.ttf'),
        italic: Rails.root.join('public', 'font', 'arial', 'Arial-ItalicMT.ttf'),
        bold_italic: Rails.root.join('public', 'font', 'arial', 'Arial-BoldItalicMT.ttf')
      }
    )
    header
    receiver_requisites
    total_by_words
    goods
    proposals
  end

  def header
    font('Arial')
    text " Перечисление вознаграждения исполнителю № #{@invoice.invoice_number} от #{@view.l(@invoice.created_at, format: :short)} г.", size: 14, style: :bold
  end

  def receiver_requisites
    move_down 2.mm
    text "Исполнитель: #{@seller['short_name']}", size: 12
    move_down 5.mm
    receiver = make_table([
                            ["#{@seller['short_name'] ? @seller['short_name'] : @seller['name']}"],
                            ['Получатель']
                          ], cell_style: { font: 'Arial', size: 10, borders: [] })
    receiver_bank = make_table([
                                 ["#{@seller['account']['bank']}"],
                                 ['Банк получателя']
                               ], cell_style: { font: 'Arial', size: 10, borders: [] })
    bic_ca = make_table([
                          ["#{@seller['account']['bic']}"],
                          ["#{@seller['account']['corr_account']}"]
                        ], cell_style: { font: 'Arial', size: 10, borders: [] })
    table([
            [{ content: receiver_bank, colspan: 2, rowspan: 2 }, 'БИК', { content: bic_ca, rowspan: 2 }],
            ['К/с. №'],
            ["ИНН #{@seller['inn']}", "КПП #{@seller['kpp']}", { content: 'Сч. №', rowspan: 3},
             { content: "#{@seller['account']['account_number']}", rowspan: 3 }],
            [{ content: receiver, colspan: 2, rowspan: 2 }]
          ], position: :center, column_widths: [48.mm, 63.mm, 19.mm, 60.mm],
             cell_style: { font: 'Arial', size: 10 })
  end

  def goods
    move_down 3.mm
    text "Назначение платежа: Оплата вознаграждения по договору оферты. Без НДС", size: 12
  end

  def total_by_words
    move_down 3.mm
    text "Сумма: #{@total} (#{RuPropisju.rublej(@total).capitalize} 00 копеек)", size: 12
  end

  def proposals
    move_down 5.mm
    order_data = services || []
    table(order_data, position: :center, column_widths: [15.mm, 90.mm, 20.mm, 15.mm, 20.mm, 30.mm],
          cell_style: { font: 'Arial', size: 8, align: :center })
  end

  def services
    prev_invoice = @profile.invoices.prev_invoice(@invoice.created_at).first
    if prev_invoice.nil?
      orders = @profile.answered_orders.where("proposal_employees.state = 'paid'")
    else
      current_date = @invoice.created_at
      prev_date = prev_invoice.created_at
      orders = @profile.orders_with_paid_employees(current_date, prev_date)
    end

    data = [table_head]
    orders.includes(:proposal_employees).decorate.each_with_index do |order, i|
      employees = prev_invoice.nil? ? (order.proposal_employees.paid.where('proposal_employees.profile_id = ?', @profile.id)) :
                                      (order.proposal_employees.paid_employees_during(@profile.id, current_date, prev_date))
      quantity = employees.count
      total = quantity * order.contractor_price
      @total_price += total

      data << [
        { content: (i + 1).to_s }, { content: "#{ order.title_with_skill }. #{ order.production_site.title }" },
        { content: quantity.to_s }, { content: 'шт' },
        { content: order.contractor_price.to_s },
        { content: total.to_s }
      ]
      employees.includes(:employee_cv).each do |employee|
        data << [{}, { content: employee_row(employee) }, {}, {}, {}, {}]
      end
    end
    data << [{ content: total_text('Итого:'), colspan: 5, border_width: 0 }, { content: @total_price.to_s }]
    data << [{ content: total_text('В том числе НДС (18%)'), colspan: 5, border_width: 0 }, {}]
    data << [{ content: total_text('Всего (с учетом НДС)'), colspan: 5, border_width: 0 }, { content: @total_price.to_s }]
    data
  end

  def table_head
    [
      { content: '№' }, { content: 'Наименование работы (услуги)' },
      { content: 'Количество' }, { content: 'Ед. изм.' },
      { content: 'Цена' }, { content: 'Сумма' }
    ]
  end

  def employee_row(employee)
    make_table([
                 [employee.employee_cv.id.to_s,
                 employee.employee_cv.name,
                 'Нанят',
                 employee.hiring_date.strftime('%d/%m/%Y')]
               ],
               column_widths: [12.mm, 48.mm, 12.mm, 18.mm],
               cell_style:    { font: 'Arial', size: 8, borders: [:top] })
  end

  def total_text(str)
    make_table([[str]],
               column_widths: [160.mm],
               cell_style:    { size:         10,
                                border_width: 0,
                                align:        :right,
                                style:        :bold })
  end
end
