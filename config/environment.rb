# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  user_name: YAML.load_file('config/secrets.yml')['sendgrid']['usn'],
  password: YAML.load_file('config/secrets.yml')['sendgrid']['pass'],
  domain: 'robinapp.herokuapp.com',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}