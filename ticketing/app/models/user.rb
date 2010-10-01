class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  validates_format_of :email, :with => /[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/
  validates_presence_of :first_name, :last_name, :userid
  validates_presence_of :student_number, :student_number_confirmation, :if => :student_number_changed?
  validates_confirmation_of :student_number, :if => :student_number_changed?

  attr_accessor :student_number, :student_number_confirmation

  # Explicitly specify which fields may be modified by mass assignment.
  # This should only include attributes the user should be able to modify themselves.
  attr_accessible :first_name, :last_name, :email, :student_number, :student_number_confirmation

  # Assigns a new student number by updating the <tt>student_number_hash</tt> attribute.
  def student_number=(new_student_number)
    unless new_student_number.blank?
      @student_number = new_student_number
      self.student_number_hash = Digest::SHA256.hexdigest(new_student_number)
    end
  end

  # Determines whether or not the student number has been modified.
  def student_number_changed?
    !@student_number.blank? || !@student_number_confirmation.blank?
  end

  # Returns a human-readable representation of a user (in the form of a full name).
  def to_s
    "%s %s" % [first_name, last_name]
  end

  # Determined whether the user has the permission given.
  # Accepts any of the following:
  #
  # Symbol::     Humanizes the symbol name and looks up a permission by that name (e.g. :eat_cake)
  # String::     Looks up a permission by the name given (e.g. "Eat cake")
  # Integer::    Looks up a permission by that ID (e.g. 4)
  # Permission:: Uses the Permission model instance given.
  #
  # Anything else returns false. A user "has" a permission if any of the
  # user's roles has that permission.
  def has_permission?(permission)
    # accept various kinds of input
    case permission
    when Symbol
      permission = Permission.find_by_name(permission.to_s.humanize)
    when String
      permission = Permission.find_by_name(permission)
    when Integer
      permission = Permission.find_by_id(permission)
    end

    # by this point, we should have an actual Permission model
    return false unless permission.is_a? Permission

    return roles.any? { |role| role.permissions.include? permission }
  end
end
