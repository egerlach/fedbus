# Permission to administer the application's access control components,
# including users and authorization.
Permission.find_or_create_by_name("Manage access control")

# Default roles
admin = Role.find_or_create_by_name("Administrator")
admin.permissions = Permission.all
admin.save!
