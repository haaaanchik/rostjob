class InvoicePdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(invoice, view)
    super(page_size: 'A4', page_layout: :portrait, margin: 10.mm)
    @invoice = invoice
    @seller = invoice.seller
    @buyer = invoice.buyer
    @goods = invoice.goods
    @total = 0
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
    seller_requisites
    invoice_number
    contract
    goods
    total
    total_by_words
    signs
  end

  def header
    font('Arial')
    text 'Внимание! Оплата данного счета означает согласие с условиями поставки товара. '\
    'Уведомление об оплате обязательно, в противном случае не гарантируется наличие товара на'\
    'складе. Товар отпускается по факту прихода денег на р/с Поставщика, самовывозом, '\
    'при наличии доверенности и паспорта.', size: 10, align: :center
  end

  def seller_requisites
    move_down 5.mm
    receiver = make_table([
                            ["#{@seller['short_name']}"],
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

  def invoice_number
    move_down 10.mm
    text "Счет на оплату № #{@invoice.invoice_number} от #{@view.l(@invoice.created_at, format: :short)} г.",
      size: 16, style: :bold
  end

  def contract
    move_down 3.mm
    table(
      [
        ['Поставщик:', { content: "#{@seller['short_name']}, ИНН #{@seller['inn']}, КПП #{@seller['kpp']}, #{@seller['address']}" }],
        ['Покупатель:', { content: "#{@buyer['short_name']}, ИНН #{@buyer['inn']}, КПП #{@buyer['kpp']}, #{@buyer['address']}" }]
      ], position: :center, column_widths: [25.mm, 165.mm],
         cell_style: { font: 'Arial', size: 10, borders: [] }
    ) do
      row(0).columns(0..1).borders = [:top]
      columns(1).font_style = :bold
    end
  end

  def goods
    move_down 3.mm
    tdata = [['№', 'Наименование товара, работ, услуг', 'Коли-чество', 'Ед. Изм.', 'Цена', 'Сумма']]
    @goods.each_with_index do |good, index|
      summ = good['price'] * good['quantity']
      @total += summ.to_i
      tdata.push([index + 1, good['title'], good['quantity'], good['unit'], good['price'], summ])
    end
    table(tdata, position: :center, column_widths: [10.mm, 103.mm, 15.mm, 12.mm, 25.mm, 25.mm],
                 cell_style: { font: 'Arial', size: 10, padding: [0, 5, 5, 5], valign: :center }) do
      row(0).columns([0, 2, 3, 4, 5]).align = :center
      row(1).columns([0, 2, 3]).align = :center
      row(1).columns([4, 5]).align = :right
    end
  end

  def total
    table([
            [{ content: 'Итого:' }, @total],
            [{ content: 'В том числе НДС:' }, 0],
            [{ content: 'Всего к оплате:' }, @total]
          ], position: :center, column_widths: [165.mm, 25.mm],
             cell_style: { font: 'Arial', size: 10, font_style: :bold, padding: [0, 5, 5, 5],
                           borders: [], valign: :center, align: :right })
  end

  def total_by_words
    move_down 3.mm
    text "Всего наименований #{@goods.count}, на сумму #{@total} руб.", size: 10
    text "#{RuPropisju.rublej(@total).capitalize} 00 копеек.", size: 10, style: :bold
  end

  def signs
    move_down 5.mm
    table([
            ['Руководитель', '', 'Иванов А.А', ''],
            ['Бухгалтер', '', 'Сидоров Б.Б.', '']
          ], position: :center, cell_style: { font: 'Arial', size: 10, padding: [40, 5, 5, 5] }) do
            cells.borders = []
            row(0).columns(0..3).borders = [:top]
            columns(0).font_style = :bold
            columns(0).width = 30.mm
            columns(1).borders = %i[bottom top]
            columns(1).width = 50.mm
            columns(2).borders = %i[bottom top]
            columns(2).width = 50.mm
            columns(2).align = :right
            columns(3).width = 60.mm
          end
  end
end
