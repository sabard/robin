class StaticsController < ApplicationController
  def home
    @pusher_key = Rails.env.production? ? ENV['PUSHER_KEY'] : YAML.load_file('config/super_secrets.yml')['pusher']['key']
  end
end