require 'highline/import'
require 'yaml'

namespace :fedbus do
  desc "Create a new installation"
  task :setup => :environment do
    # intro message
    say "
<%= color(' FedBus Ticketing Setup ', BOLD, YELLOW, ON_BLACK) %>
<%= color('========================', BOLD, YELLOW, ON_BLACK) %>

Welcome to the FedBus Ticketing installation.

This process will walk you through the steps needed to get the FedBus
Ticketing application set up and ready to go. If at any time you need
to cancel, simply terminate the process (typically Ctrl+C).

Rails environment: <%= color Rails.env, CYAN %>

"

    %w(db admin additional).each { |task| Rake::Task["fedbus:setup:#{task}"].invoke }
  end

  namespace :setup do
    task :db => :environment do
      db_config = YAML.load_file(File.join(Rails.root, "config", "database.yml"))[Rails.env]
      db_config["password"] = "(not shown)" unless db_config["password"].blank?

      say "Here are your current database settings:"
      say db_config.to_yaml
      say "---"
      say "These can be adjusted in config/database.yml."
      agree("OK to proceed? ") || exit

      %w(db:create db:migrate db:seed).each { |task| Rake::Task[task].invoke }
    end

    task :admin do
      Rake::Task["fedbus:admin"].invoke if agree("Would you like to add an administrator? ")
    end

    task :additional do
      say "
Please change the following manually, if desired:
  * CAS base URL (if not using cas.uwaterloo.ca), in config/initializers/cas.rb
"
    end
  end
end
