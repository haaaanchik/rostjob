class OrderSearchForm2
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :query, :sort_by, :filter_by, :employee_cv_id, :profile

  validates :sort_by, inclusion: { in: %w[date_asc date_desc reward_asc reward_desc] }
  validates :filter_by, inclusion: { in: %w[day 3day week all_time] }

  def initialize(attrs = {})
    attrs ||= {}
    defaults = {
      query: '',
      sort_by: 'date_desc',
      filter_by: 'all_time'
    }

    attrs_with_defaults = defaults.merge(attrs)
    attrs_with_defaults.each { |k, v| instance_variable_set("@#{k}", v) }
  end

  def persisted?
    false
  end

  def submit
    if valid?
      sort_by_sym = "sort_by_#{sort_by}".to_sym
      filter_by_sym = "filter_by_#{filter_by}".to_sym
      if query.empty?
        profile.favorites.decorate
      else
        Order.published.without_favorites_of(profile).send(:by_query, query).send(sort_by_sym).send(filter_by_sym).decorate
      end
    else
      profile.favorites.decorate
    end
  end

  def sort_by_list
    [
      OpenStruct.new(key: :date_asc, label: 'Дата по возрастанию'),
      OpenStruct.new(key: :date_desc, label: 'Дата по убыванию'),
      OpenStruct.new(key: :reward_asc, label: 'Вознаграждение по возрастанию'),
      OpenStruct.new(key: :reward_desc, label: 'Вознаграждение по убыванию')
    ]
  end

  def filter_by_list
    [
      OpenStruct.new(key: :day, label: 'сутки'),
      OpenStruct.new(key: '3day', label: 'три дня'),
      OpenStruct.new(key: :week, label: 'неделю'),
      OpenStruct.new(key: :all_time, label: 'всё время')
    ]
  end
end