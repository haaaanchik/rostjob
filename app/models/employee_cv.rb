class EmployeeCv < ApplicationRecord
  include AASM
  include EmployeeCvRepository

  has_many :proposal_employees
  has_many :orders, through: :proposal_employees
  has_one :crm_columns_employee_cv, dependent: :destroy
  accepts_nested_attributes_for :crm_columns_employee_cv

  belongs_to :proposal, optional: true
  belongs_to :order, optional: true
  belongs_to :profile, optional: true

  validates :name, presence: true
  validates :phone_number, phone: true, unless: :careerist_job
  validates :super_job_id, uniqueness: true, if: :super_job_id
  validates :name, uniqueness: true, if: :careerist_job

  ransack_alias :employee_cvs_fields, :id_or_name_or_phone_number

  attr_accessor :mark_ready
  has_attached_file :document
  validates_attachment_content_type :document, content_type: /.*\/.*\z/
  has_attached_file :photo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/img/no-avatar.jpg'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  before_create :check_state
  before_save :check_marks

  def initialize(attrs = nil)
    defaults = {
      passport: {
        seria: nil,
        number: nil,
        code: nil,
        date: nil,
        issuer: nil,
        reg_address: nil
      }
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  strip_attributes only: :name

  aasm column: :state, skip_validation_on_save: true,
       no_direct_assignment: false, whiny_transitions: false do
    # черновик
    state :draft, initial: true
    # готова к отправке
    state :ready
    # отправлена
    state :sent
    # открыт спор
    state :disputed
    # удалена
    state :deleted

    event :to_sent do
      transitions from: :ready, to: :sent
    end

    event :to_deleted do
      transitions from: %i[draft ready], to: :deleted
    end

    event :to_disputed do
      transitions from: :sent, to: :disputed
    end

    event :to_ready do
      transitions from: %i[sent draft deleted], to: :ready
    end

    event :revoke do
      transitions from: :sent, to: :ready, guard: :may_revoke?
    end

    # event :hire do
    #   transitions from: :applyed, to: :hired
    #   after do
    #     ps_s = proposal_employees.select {|d| d.proposal_id == proposal_id}
    #     ps_s.map(&:hire!)
    #     ps = proposal_employees.reject {|d| d.proposal_id == proposal_id}
    #     ps.map(&:destroy)
    #   end
    # end
  end

  def may_revoke?
    true
  end

  def self.ext_data_fields
    %i[pser pnum pdate pcode address phone_alt education experiense remark]
  end

  def self.possible_states
    aasm.states.map(&:name)
  end

  def with_mobile
    "#{name}; тел: #{phone}"
  end

  def phone
    vals = (ext_data || {})
    vals.fetch('phone', nil).to_s
  end

  def ext_data_phone
    return unless phone.empty?
    errors.add(:ext_data, 'Контактный телефон')
  end

  def check_marks
    return unless mark_ready
    self.state = :ready
  end

  def create_pr_empl(proposal_id)
    prp = Proposal.find_by id: proposal_id
    proposal_employees.create proposal_id: prp.id, order_id: prp.order_id,
                              profile_id: profile_id,
                              marks: {viewed_by_customer: false}
  end

  def rempve_pr_empl(proposal_id)
    empl = proposal_employees.where(proposal_id: proposal_id).first
    proposal_employees.destroy empl
  end

  def check_state
    return if proposal_id.blank?
    create_pr_empl(proposal_id)
    self.state = :applyed
    self.proposal_id = nil
  end

  def self.customer_menu_items
    %w[inbox hired disputed deleted]
  end

  def self.contractor_menu_items
    EmployeeCv.aasm.states.map(&:name)
  end

  def self.customer_menu_item_by_state(state)
    self.customer_menu_items.find { |_key, values| values.include? state }.first
  end

  ransacker :id do
    Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
  end

  def mail_with_to_sent
    SendNotifyMailJob.perform_now(objects: self, method: 'emp_cv_sended') if order.profile.notify_mails?
  end
end
