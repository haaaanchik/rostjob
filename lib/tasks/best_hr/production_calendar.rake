namespace :best_hr do
  namespace :seed do
    desc 'Creates production calendar'
    task production_calendar: :environment do
      p 'Создаём производственный календарь'
      # 2018
      data = [
        %w[1 2 3 4 5 6 7 8 13 14 20 21 27 28], # jan
        %w[3 4 10 11 17 18 23 24 25], # feb
        %w[3 4 8 9 10 11 17 18 24 25 31], # mar
        %w[1 7 8 14 15 21 22 29 30], # apr
        %w[1 2 5 6 9 12 13 19 20 26 27], # may
        %w[2 3 10 11 12 16 17 23 24 30], # jun
        %w[1 7 8 14 15 21 22 28 29], # jul
        %w[4 5 11 12 18 19 25 26], # aug
        %w[1 2 8 9 15 16 22 23 29 30], # sep
        %w[6 7 13 14 20 21 27 28], # oct
        %w[3 4 5 10 11 17 18 24 25], # nov
        %w[1 2 8 9 15 16 22 23 30 31] # dec
      ]
      create_calendar(2018, data)

      # 2019
      data = [
        %w[1 2 3 4 5 6 7 8 12 13 19 20 26 27], # jan
        %w[2 3 9 10 16 17 23 24], # feb
        %w[2 3 8 9 10 16 17 23 24 30 31], # mar
        %w[6 7 8 13 14 20 21 27 28], # apr
        %w[1 2 3 4 5 9 10 11 12 18 19 25 26], # may
        %w[1 2 8 9 12 15 16 22 23 29 30], # jun
        %w[6 7 13 14 20 21 27 28], # jul
        %w[3 4 10 11 17 18 24 25 31], # aug
        %w[1 7 8 14 15 21 22 28 29], # sep
        %w[5 6 12 13 19 20 26 27], # oct
        %w[2 3 4 9 10 16 17 23 24 30], # nov
        %w[1 7 8 14 15 21 22 28 29] # dec
      ]
      create_calendar(2019, data)
    end

    def create_calendar(year, data)
      holidays = []
      data.each_with_index do |month, index|
        year_month = "#{year}-#{(index + 1).to_s.rjust(2, '0')}-"
        month.each do |day|
          holidays.push(date: Date.strptime(year_month + day.rjust(2, '0')))
        end
      end
      Holiday.create!(holidays)
    end
  end
end
