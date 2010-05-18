class User < ActiveRecord::Base

  validates_format_of :email, :with => /[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/
  validates_presence_of :first_name, :last_name
  validates_presence_of :student_number, :student_number_confirmation, :if => :student_number_changed?
  validates_confirmation_of :student_number

  attr_accessor :student_number, :student_number_confirmation

  def student_number=(n)
    @student_number=n
    @student_number_hash = Digest::SHA256.hexdigest(n)
  end

  def student_number_changed?
    @student_number || @student_number_confirmation
  end

end
