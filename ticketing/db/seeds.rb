# Permission to administer the application's access control components,
# including users and authorization.
Permission.find_or_create_by_name("Manage access control")
Permission.find_or_create_by_name("Trips")
Permission.find_or_create_by_name("Buses")
Permission.find_or_create_by_name("Blackouts")
Permission.find_or_create_by_name("Holidays")
Permission.find_or_create_by_name("Reading weeks")
Permission.find_or_create_by_name("View admin panel")
Permission.find_or_create_by_name("Tickets")
Permission.find_or_create_by_name("Destinations")

# Default roles
admin = Role.find_or_create_by_name("Administrator")
admin.permissions = Permission.all
admin.save!
