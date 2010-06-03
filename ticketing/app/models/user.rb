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
end
