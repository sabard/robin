require 'pusher'

Pusher.app_id = Rails.env.production? ? ENV['PUSHER_APP_ID'] : YAML.load_file('config/super_secrets.yml')['pusher']['app_id']
Pusher.key = Rails.env.production? ? ENV['PUSHER_KEY'] : YAML.load_file('config/super_secrets.yml')['pusher']['key']
Pusher.secret = Rails.env.production? ? ENV['PUSHER_SECRET'] : YAML.load_file('config/super_secrets.yml')['pusher']['secret']
Pusher.logger = Rails.logger