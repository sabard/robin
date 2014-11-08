require "uri"
require "net/http"

class EventsController < ApplicationController

  def trigger
    @type = params[:type]

    case @type
    when 'accident'
      if Rails.env.production?
        sid = ENV['TWILIO_SID']
        secret = ENV['TWILIO_SECRET']
        num = ENV['TWILIO_NUM']
      else
        sid = YAML.load_file('config/secrets.yml')['twilio']['sid']
        secret = YAML.load_file('config/secrets.yml')['twilio']['token']
        num = YAML.load_file('config/secrets.yml')['twilio']['number']
      end
      twilio_client = Twilio::REST::Client.new sid, secret
      twilio_client.account.sms.messages.create(
        from: "#{num}",
        to: "+17329304455",
        body: "An accident has occurred!"
      )

      Notifier.trigger_response("sabar.dasgupta@gmail.com").deliver
    end

    render nothing: true
  end

  def test_post
    if Rails.env.production?
      secret = ENV['SECRET']
    else
      secret = YAML.load_file('config/secrets.yml')['toyota']['secret']
    end
    

    params =  {
      developerkey: secret,
      responseformat: 'json',
      userid: 'ITCUS_USERID_092'
    }
    x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetUserInfo'), params)
    @user_info = x.body

    params = {
      developerkey: secret,
      responseformat: 'json',
      userid: 'ITCJP_USERID_038',
      infoids: '[VehSt10]'
    }

    x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetVehicleInfo'), params)
    @vehicle_info = x.body

    render json: [@user_info, @vehicle_info]
  end
end
