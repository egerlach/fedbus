Rails.application.config.session_secret = File.open(File.join(Rails.root, "config", "session_secret"), "a+") { |f| f.write(ActiveSupport::SecureRandom.hex(64)) } 
