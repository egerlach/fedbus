class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  validates_format_of :email, :with => /[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/
  validates_presence_of :first_name, :last_name, :userid
  validates_presence_of :student_number, :student_number_confirmation, :if => :student_number_changed?
  validates_confirmation_of :student_number, :if => :student_number_changed?

  attr_accessor :student_number, :student_number_confirmation
  attr_protected :userid

  def student_number=(new_student_number)
    unless new_student_number.blank?
      @student_number = new_student_number
      self.student_number_hash = Digest::SHA256.hexdigest(new_student_number)
    end
  end

  def student_number_changed?
    !@student_number.blank? || !@student_number_confirmation.blank?
  end

  def to_s
    "%s %s" % [first_name, last_name]
  end

  def has_permission?(permission)
    # accept various kinds of input
    if permission.is_a? Symbol
      permission = Permission.find_by_name(permission.to_s.humanize)
    elsif permission.is_a? String
      permission = Permission.find_by_name(permission)
    elsif permission.is_a? Integer
      permission = Permission.find_by_id(permission)
    end

    # by this point, we should have an actual Permission model
    return false unless permission.is_a? Permission

    return roles.any? { |role| role.permissions.include? permission }
  end
end
