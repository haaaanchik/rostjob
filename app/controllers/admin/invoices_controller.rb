class Admin::InvoicesController < Admin::ApplicationController
  def index
    paginated_invoices
  end

  def pay
    result = Cmd::Admin::Invoice::Pay.call(invoice: invoice,
                                           amount: invoice.amount,
                                           profile: invoice.profile,
                                           reasons_text: 'Пополнение баланса')

    if result.success?
      flash[:notice] = 'Cчёт оплачен'
    else
      flash[:alert] = 'Ошибка'
    end

    redirect_to admin_invoices_path
  end

  def destroy
    if invoice.destroy
      flash[:notice] = 'Счёт успешно удалён'
    else
      flash[:alert] = 'Ошибка при удаление счёта'
    end

    redirect_to admin_invoices_path
  end

  def invoices_by_bank
    @invoices = [ {
                              "id" => "189",
                            "date" => "2021-02-18",
                          "amount" => 20000,
                        "drawDate" => "2021-02-18",
                       "payerName" => "ООО \"ВОЛКОМОЛКО\"",
                        "payerInn" => "7734347383",
                    "payerAccount" => "40702810138000024405",
                "payerCorrAccount" => "30101810400000000225",
                        "payerBic" => "044525225",
                       "payerBank" => "ПАО СБЕРБАНК",
                      "chargeDate" => "2021-02-18",
                       "recipient" => "ООО \"РОСТДЖОБ\"",
                    "recipientInn" => "1650390021",
                "recipientAccount" => "40702810110000671587",
            "recipientCorrAccount" => "30101810145250000974",
                    "recipientBic" => "044525974",
                   "recipientBank" => "АО \"ТИНЬКОФФ БАНК\"",
                   "operationType" => "01",
                  "paymentPurpose" => "Оплата за Услуги по размещению заявки на поиск персонала по счету N 401 от 17 февраля 2021 г. Сумма 20000-00 НДС не облагается.",
                   "creatorStatus" => "",
                        "payerKpp" => "773301001",
                    "recipientKpp" => "165001001",
                  "executionOrder" => "5"
        },
         {
                              "id" => "29",
                            "date" => "2021-02-20",
                          "amount" => 52001,
                        "drawDate" => "2021-02-20",
                       "payerName" => "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"РОСТДЖОБ\"",
                        "payerInn" => "1650390021",
                    "payerAccount" => "40702810110000671587",
                "payerCorrAccount" => "30101810145250000974",
                        "payerBic" => "044525974",
                       "payerBank" => "АО \"ТИНЬКОФФ БАНК\"",
                      "chargeDate" => "2021-02-20",
                       "recipient" => "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"РОСТДЖОБ\"",
                    "recipientInn" => "1650390021",
                "recipientAccount" => "40702810910000656090",
            "recipientCorrAccount" => "30101810145250000974",
                    "recipientBic" => "044525974",
                   "recipientBank" => "АО \"ТИНЬКОФФ БАНК\"",
                   "operationType" => "01",
                  "paymentPurpose" => "Перевод собственных средств. НДС не облагается.",
                   "creatorStatus" => "",
                  "executionOrder" => "5"
        } ]
  end

  private

  def balance
    invoice.profile.balance
  end

  def paginated_invoices
    @paginated_invoices ||= invoices.page(params[:page])
  end

  def invoice
    @invoice ||= Invoice.find(params[:id])
  end

  def invoices
    @invoices ||= Invoice.customers.order(created_at: :desc)
  end
end
