class AccountStatementsUpload
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :file
  attr_accessor :documents

  validate :file_presence_and_content_validity

  def initialize(attributes = {})
    return if attributes.nil?
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def file_presence_and_content_validity
    errors.add(:file, 'не может быть пустым') unless file
    return unless file
    result = Cmd::AccountStatements::Parse.call(file: file)
    errors.add(:file, result.errors) unless result.success?
    send('documents=', result.documents)
  end

  def persisted?
    false
  end
end
