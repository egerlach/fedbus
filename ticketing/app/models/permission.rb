class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles
  validates_presence_of :name
  validates_uniqueness_of :name
  
  #Properly capitalizes the permission name because otherwise we'll get problems elsewhere.
  def name=(new_name)
    write_attribute(:name, new_name.capitalize)
  end
  
end
