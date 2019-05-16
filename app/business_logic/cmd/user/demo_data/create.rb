module Cmd
  module User
    module DemoData
      class Create
        include Interactor

        def call
          if profile.profile_type == 'customer'
            profile.balance.deposit(100000, 'Пополнение баланса')
            profile.create_company(company_params)
            context.contractors = []
            context.employee_cvs = []
            context.proposal_employees = []
            context.orders = []
            context.order_templates = []

            3.times do
              result = Cmd::User::Registration::CreateContractor.call(user_params: contractor_params)
              contractors << result.user if result.success?
            end

            contractors.each do |contractor|
              profile = contractor.profile

              3.times do
                result = Cmd::EmployeeCv::CreateAsReady.call(params: employee_cv_params, profile: profile)
                context.employee_cvs << result.employee_cv if result.success?
              end
              Cmd::EmployeeCv::ToDeleted.call(employee_cv: employee_cvs.last)
            end

            3.times do |n|
              result = Cmd::OrderTemplate::Create.call(profile: profile, params: order_template_params[n], position: true)
              context.order_templates << result.order_template if result.success?
            end

            order_templates.each do |order_template|
              result = Cmd::OrderTemplate::CreateOrder.call(order_template: order_template)
              result = Cmd::Order::ToModeration.call(order: result.order) if result.success?
              result = Cmd::Order::ToPublished.call(order: result.order) if result.success?
              context.orders << result.order if result.success?
            end
            context.orders.last.to_completed

            result = Cmd::ProposalEmployee::Create.call(profile: contractors_profiles.first, params: proposal_employee_params.first)
            if result.success?
              context.proposal_employees << result.proposal_employee
              Cmd::EmployeeCv::ToSent.call(employee_cv: result.proposal_employee.employee_cv, log: false)
              candidate = result.proposal_employee
              hiring_date = Date.today
              candidate.update(hiring_date: hiring_date, warranty_date: Holiday.warranty_date(hiring_date))
              Cmd::ProposalEmployee::Hire.call(candidate: candidate)
            end

            result = Cmd::ProposalEmployee::Create.call(profile: contractors_profiles.first, params: proposal_employee_params.second)
            if result.success?
              context.proposal_employees << result.proposal_employee
              Cmd::EmployeeCv::ToSent.call(employee_cv: result.proposal_employee.employee_cv, log: false)
            end

            result = Cmd::ProposalEmployee::Create.call(profile: contractors_profiles.second, params: proposal_employee_params.third)
            if result.success?
              context.proposal_employees << result.proposal_employee
              Cmd::EmployeeCv::ToSent.call(employee_cv: result.proposal_employee.employee_cv, log: false)
            end

            result = Cmd::ProposalEmployee::Create.call(profile: contractors_profiles.first, params: proposal_employee_params.fourth)
            if result.success?
              context.proposal_employees << result.proposal_employee
              Cmd::EmployeeCv::ToSent.call(employee_cv: result.proposal_employee.employee_cv, log: false)
            end

            result = Cmd::ProposalEmployee::Create.call(profile: contractors_profiles.second, params: proposal_employee_params.fifth)
            if result.success?
              context.proposal_employees << result.proposal_employee
              Cmd::EmployeeCv::ToSent.call(employee_cv: result.proposal_employee.employee_cv, log: false)
              candidate = result.proposal_employee
              hiring_date = Date.today
              candidate.update(hiring_date: hiring_date, warranty_date: Holiday.warranty_date(hiring_date))
              Cmd::ProposalEmployee::Hire.call(candidate: candidate)
            end
          end
        end

        private

        def contractors
          context.contractors
        end

        def employee_cvs
          context.employee_cvs
        end

        def proposal_employees
          context.proposal_employees
        end

        def orders
          context.orders
        end

        def order_templates
          context.order_templates
        end

        def proposal_employee_params
          [
            {
              order_id: orders.first.id,
              employee_cv_id: contractors_profiles.first.employee_cvs.first.id,
              arrival_date: Date.today
            },
            {
              order_id: orders.first.id,
              employee_cv_id: contractors_profiles.first.employee_cvs.second.id,
              arrival_date: Date.today
            },
            {
              order_id: orders.first.id,
              employee_cv_id: contractors_profiles.second.employee_cvs.first.id,
              arrival_date: Date.today
            },
            {
              order_id: orders.second.id,
              employee_cv_id: contractors_profiles.first.employee_cvs.third.id,
              arrival_date: Date.today
            },
            {
              order_id: orders.second.id,
              employee_cv_id: contractors_profiles.second.employee_cvs.second.id,
              arrival_date: Date.today
            },
          ]
        end

        def contractors_profiles
          contractors.map(&:profile)
        end

        def profile
          context.profile
        end

        def contractor_params
          # password = Faker::Internet.password
          password = '12345678'
          {
            full_name: Faker::Name.name,
            email: "recruiter-#{Time.current.to_i}@#{Faker::Internet.domain_name}",
            password: password,
            password_confirmation: password,
            confirmed_at: Time.current
          }
        end

        def employee_cv_params
          {
            name: Faker::Name.name,
            birthdate: Faker::Date.birthday(18, 65),
            phone_number: Faker::PhoneNumber.phone_number,
            phone_number_alt: Faker::PhoneNumber.phone_number,
            experience: experience,
            education: education,
            remark: remark,
            gender: 'М',
            passport: passport
          }
        end

        def experience
          <<~HEREDOC
            май 2000 г. – май 2001 г.
            Прохождение годовой практики в ООО «Автомобилист»,
            г. Тольятти. Функциональные обязанности:
            — разборка, чистка и мойка деталей;
            — дефектация, замена поврежденных и изношенных деталей;
            — сборка и регулировка карбюратора.
          HEREDOC
        end

        def education
          <<~HEREDOC
            сентябрь 1995 г.
            – июнь 1998 г., Профессиональное училище №39 г.  Тольятти, специализация «Слесарь-механик» (дневная форма обучения) сентябрь 1998 г.
            – май 2000 г., Технический колледж ВАЗа, факультет «Автомобильное машиностроение», специальность «Технология машиностроения», диплом специалиста (заочная форма обучения).
          HEREDOC
        end

        def remark
          <<~HEREDOC
            Семейное положение: женат.
            Дети: нет.
            Возможность командировок: да.
            Хобби: занятия в тренажерном зале.
          HEREDOC
        end

        def passport
          {
            seria: '0000',
            number: '000000',
            code: '000-000',
            date: Date.parse('01-01-1980'),
            reg_address: 'г.Москва, ул. Ленина, д. 1, кв. 1'
          }
        end

        def order_template_params
          [
            {
              name: 'Сварщики на завод ЖБИ',
              title: 'Электросварщик на автоматических и полу- автоматических машинах. 3 разряд.',
              place_of_work: 'Завод Железо-бетонных изделий',
              city: 'г.Алексин',
              salary: '61 000 - 65 000',
              experience: 'Удостоверение, трудовая книжка',
              description: 'Сварка арматурной сетки.',
              work_period: 'Постоянно',
              schedule: '6/1 - 12 - дневные смены',
              other_info: {
                age_from: 27,
                age_to: 55,
                sex: 'муж.',
                terms: 'Вахта 60/30, компенсация проезда, жилье за счет Работодателя. Сотрудникам готовым работать без межвахтового отпуска предусмотрена гибкая система лояльности. Своевременная выплата заработанной платы 2 раза в месяц. ',
                related_profession: 'Смежная профессия приветствуется',
                remark: 'Дополнительные требования к кандидату: - Наличие гражданства РФ; - Опыт работы не менее 3х месяцев.  Работнику при себе иметь: - Постельное белье, одеяло; - Средства личной гигиены; - Кухонная утварь.',
              },
              number_of_employees: 5,
              customer_price: 4000,
              contractor_price: 1000,
              base_customer_price: 4000,
              base_contractor_price: 1000,
              customer_total: 20000,
              contractor_total: 5000,
              position_id: 1,
              urgency: 'middle',
              contact_person: {
                name: 'Александр',
                phone: '+7(922)-222-11-11'
              }
            },
            {
              name: 'СМР',
              title: 'Слесарь механосборочных работ (3-5 разряд)',
              place_of_work: 'ОАО ПФ "КМТ"',
              city: 'г.Ломоносов',
              salary: '60 000 - 65 000',
              experience: 'Удостоверение, трудовая книжка',
              description: 'Сборка агрегатных узлов и механизмов.',
              work_period: 'Постоянно',
              schedule: '6/1 - 11',
              other_info: {
                age_from: 18,
                age_to: 55,
                sex: 'муж.',
                terms: 'Работа вахтовым методом 60/30, жилье за счет работодателя. К сотрудникам готовым работать без межвахтового отпуска применяется дополнительная система лояльности. Компенсация медицинского осмотра, а также компенсация проезда работникам в случае возвращения из межвахтового отпуска. ',
                related_profession: 'Смежная профессия приветствуется',
                remark: 'Работники осуществляют работу на производственной площадке КМТ - производство компонентов для транспорта, в том числе оконных и дверных систем, систем доступа пассажиров в вагон и многих других комплектующих для железнодорожного, городского транспорта, а также оборудования для станций метрополитена.',
              },
              number_of_employees: 5,
              customer_price: 4000,
              contractor_price: 1000,
              base_customer_price: 4000,
              base_contractor_price: 1000,
              customer_total: 20000,
              contractor_total: 5000,
              position_id: 2,
              urgency: 'high',
              contact_person: {
                name: 'Андрей',
                phone: '+7(922)-222-22-22'
              }
            },
            {
              name: 'Разнорабочие',
              title: 'Разнорабочий (Без опыта работы)',
              place_of_work: 'Домостроительный комбинат "ПИК-Индустрия". Строительство жилых домов.',
              city: 'г.Москва',
              salary: '45 000',
              experience: 'Не требуется',
              description: 'Выполнение неквалифицированных видов работ на стройплощадке Заказчика. Разноска, затарка, уборка мусора и пр.',
              work_period: 'Постоянно',
              schedule: '6/1 - 12 - дневные смены',
              other_info: {
                age_from: 27,
                age_to: 48,
                sex: 'муж.',
                terms: 'Вахта 60/30, компенсация проезда, жилье за счет Работодателя. Сотрудникам готовым работать без межвахтового отпуска предусмотрена гибкая система лояльности. Своевременная выплата заработанной платы 2 раза в месяц.',
                related_profession: 'Смежная профессия приветствуется',
                remark: 'Дополнительные требования к кандидату: - Наличие гражданства РФ; - Опыт работы не менее 3х месяцев.  Работнику при себе иметь: - Постельное белье, одеяло; - Средства личной гигиены; - Кухонная утварь.',
              },
              number_of_employees: 5,
              customer_price: 4000,
              contractor_price: 1000,
              base_customer_price: 4000,
              base_contractor_price: 1000,
              customer_total: 20000,
              contractor_total: 5000,
              position_id: 3,
              urgency: 'low',
              contact_person: {
                name: 'Евгений',
                phone: '+7(922)-333-33-33'
              }
            }
          ]
        end

        def company_params
          name = Faker::Company.name
          address = Faker::Address.full_address
          {
            name: name,
            short_name: name,
            address: address,
            mail_address: address,
            phone: Faker::PhoneNumber.phone_number,
            fax: Faker::PhoneNumber.phone_number,
            email: Faker::Internet.email,
            director: Faker::Name.name,
            acts_on: 'устава',
            inn: '1234567890',
            kpp: '1234567890',
            ogrn: '1234567890',
            legal_form: 'company'
          }
        end
      end
    end
  end
end
