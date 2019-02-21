class ContractorInvoicePdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(invoice, view)
    super(page_size: 'A4', page_layout: :portrait, margin: 10.mm)
    @invoice = invoice
    @seller = invoice.seller
    @buyer = invoice.buyer
    @goods = invoice.goods
    @total = invoice.amount
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
end
