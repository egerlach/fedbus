class User < ActiveRecord::Base

  validates_format_of :email, :with => /[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/

  def student_number=(n)
    self.student_number_hash = Digest::SHA256.hexdigest(n)
  end
end
