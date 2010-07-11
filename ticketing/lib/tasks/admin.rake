require 'highline/import'

namespace :fedbus do
  desc "Add an administrative user"
  task :admin, :userid, :needs => :environment do |t, args|
    userid = args[:userid] || ask("User ID: ") { |uid| uid.validate = /^[a-z\d]+$/ }

    admin_role = Role.find_by_name("Administrator")

    if admin_role.nil?
      say "Administrator role not found. Please seed the database."
      say "You can do this by running 'rake db:seed'."
      say "This is also done as part of 'rake fedbus:setup' process."
      exit
    end

    user = User.find_by_userid(userid)

    if user.nil?
      agree("User '#{userid}' not found. Register? ") || exit
      user = register_user(userid) || exit
    end

    user.roles << Role.find_by_name("Administrator")
    user.save!

    say "User '#{user.userid}' is now an administrator."
  end
end

def register_user(userid)
  form_info = [
    [:first_name, "First Name", /.+/],
    [:last_name, "Last Name", /.+/],
    [:email, "Email Address", /[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`\{|\}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/],
    [:student_number, "Student No. (optional)", /^\d*$/]
  ]

  user_attribs = form_info.inject({}) do |attribs, field|
    attribute, question, regex = *field
    attribs.merge attribute => ask("#{question}: ".rjust(24)) { |q| q.validate = regex }
  end

  unless user_attribs[:student_number].blank?
    user_attribs[:student_number_confirmation] = ask("Student No. (again): ".rjust(24)) { |q| q.validate = /^\d+$/ }
  end

  user = User.new(user_attribs)
  user.userid = userid

  unless user.save
    say ""
    say "Unable to register user. Errors:"

    for error in user.errors
      attrib, message = *error
      say "  * #{attrib.humanize} #{message}."
    end

    nil
  else
    say "User '#{userid}' registered."
    user
  end
end