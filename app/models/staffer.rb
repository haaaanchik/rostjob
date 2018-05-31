class Staffer < ApplicationRecord
  before_validation :set_guid
  attr_accessor :staffer_roles

  validates :name, presence: true
  validates :login, presence: true, uniqueness: true
  validates :guid, presence: true

  has_secure_password

  STAFF_ROLES = %w[admin moderator].freeze

  royce_roles STAFF_ROLES

  def self.roles_list
    STAFF_ROLES.map do |role|
      OpenStruct.new(role: role, label: role)
    end
  end

  def staffer_roles
    @staffer_roles = role_list
  end

  def staffer_roles=(roles = [])
    role_list.each do |role|
      remove_role role
    end

    roles.reject!(&:empty?)

    roles.each do |role|
      add_role role
    end
  end

  def set_guid
    self.guid = SecureRandom.uuid
  end
end
