# frozen_string_literal: true

class ProposalEmployeeInvoicesPdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(proposal_employee, view)
    super(page_size: 'A4', page_layout: :portrait, margin: 10.mm)
    @proposal_employee = proposal_employee
    @total_price = proposal_employee.order.contractor_price
    @view = view

    font_families.update(
      'Arial' => { normal: Rails.root.join('public', 'font', 'arial', 'ArialMT.ttf'),
                   bold: Rails.root.join('public', 'font', 'arial', 'Arial-BoldMT.ttf'),
                   italic: Rails.root.join('public', 'font', 'arial', 'Arial-ItalicMT.ttf'),
                   bold_italic: Rails.root.join('public', 'font', 'arial', 'Arial-BoldItalicMT.ttf') }
    )

    header
    requisites_customer
    proposals
    total
    total_amount
    goods
    signs
    services
  end

  def header
    font('Arial')
    text "Акт #{@proposal_employee.id} от #{@view.l(@proposal_employee.created_at, format: :short)} г.", style: :bold
  end

  def requisites_customer
    move_down 3.mm
    table(
      [
        ['Исполнитель: ', { content: 'ООО "РостДжоб", ИНН 1650390021, 423810, Набережные Челны, Академика Рубаненко, дом № 4, офис 359, тел: 8(909)312-26-00, р/с 40702810910000656090, в банке АО "ТИНЬКОФФ БАНК", БИК 044525974, к/с 30101810145250000974 ' }],
        ['Заказчик:', { content: "#{@proposal_employee.order.profile.company.short_name}, #{@proposal_employee.order.profile.company.inn}, #{@proposal_employee.order.profile.company.kpp}, #{@proposal_employee.order.profile.company[:address]},
                                   р/с #{@proposal_employee.order.profile.company.active_account.account_number}, в банке #{@proposal_employee.order.profile.company.active_account.bank}, БИК #{@proposal_employee.order.profile.company.active_account.bic}, к/с #{@proposal_employee.order.profile.company.active_account.corr_account}" }],
        ['Основание:', { content: 'Основной договор' }]
      ], position: :center, column_widths: [30.mm], cell_style: { font: 'Arial', size: 11, borders: [] }
    ) do
      row(0).columns(0..1).borders = [:top]
      columns(1).font_style = :bold
    end
  end

  def proposals
    move_down 5.mm
    order_data = services || []
    table(order_data, position: :center, column_widths: [15.mm, 90.mm, 20.mm, 15.mm, 20.mm, 30.mm],
                      cell_style: { font: 'Arial', size: 9, align: :center })
  end

  def table_head
    [
      { content: '№' }, { content: 'Наименование работ, услуг' },
      { content: 'Кол-во' }, { content: 'Ед' },
      { content: 'Цена' }, { content: 'Сумма' }
    ]
  end

  def services
    data = [table_head]
    data << [
      { content: '1'.to_s }, { content: "Оказание услуг по подбору персонала (#{@proposal_employee.employee_cv.name})" },
      { content: '' }, { content: '' },
      { content: @total_price.to_s }, { content: @total_price.to_s }
    ]
    data
  end

  def total
    table([[{ content: 'Итого:' }, @total_price], [{ content: 'Без налога(НДС)' }]], column_widths: [160.mm, 20.mm],
                                                                                     cell_style: { font: 'Arial',
                                                                                                   size: 11,
                                                                                                   font_style: :bold,
                                                                                                   padding: [0, 5, 5, 5],
                                                                                                   borders: [],
                                                                                                   valign: :center,
                                                                                                   align: :right })
  end

  def total_amount
    table([[{ content: "Всего оказано услуг: 1, на сумму #{@total_price}" }]], column_widths: [165.mm, 25.mm],
                                                                               cell_style: { font: 'Arial',
                                                                                             size: 9,
                                                                                             padding: [0, 5, 5, 5],
                                                                                             borders: [],
                                                                                             valign: :center,
                                                                                             align: :left })

    table([[{ content: "#{RuPropisju.rublej(@total_price).capitalize} 00 копеек" }]], column_widths: [165.mm, 25.mm],
                                                                                      cell_style: { font: 'Arial',
                                                                                                    size: 11,
                                                                                                    padding: [0, 5, 5, 5],
                                                                                                    borders: [],
                                                                                                    font_style: :bold })
  end

  def goods
    move_down 5.mm
    table([[{ content: 'Вышеперечисленные услуги выполнены полностью и в строк. Заказчик притензии и объему, качеству и срокам оказания услуг не имеет' }]],
          column_widths: [165.mm, 25.mm], cell_style: { font: 'Arial', size: 11, borders: [:bottom] })
  end

  def signs
    move_down 9.mm
    table([[{ content: 'Исполнитель', size: 12, font_style: :bold },
            { content: 'Заказчик', size: 12, font_style: :bold }],
           [{ content: 'Гениральный директор ООО "РостДжоб"', size: 9 },
            { content: @proposal_employee.order.profile.user.full_name, size: 9 }],
           [{}, {}],
           [{}, {}],
           [{}, {}],
           [{ content: '_______________________________' }, { content: '_______________________________' }],
           [{ content: 'Юсупов И.И', size: 9 }]], column_widths: [100.mm, 90.mm],
                                                  cell_style: { font: 'Arial',
                                                                padding: [0, 5, 5, 5],
                                                                borders: [],
                                                                align: :left })
  end
end
