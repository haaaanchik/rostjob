Ransack.configure do |config|
  config.add_predicate 'between_begin_and_end',
                        arel_predicate: 'between_begin_and_end',
                        formatter: proc { |v| v.to_date },
                        validator: proc { |v| v.present? },
                        type: :string
end

module Arel
  module Predications
    def between_begin_and_end(date)
      gteq(date.to_date.beginning_of_day).and(lt(date.end_of_day))
    end
  end
end