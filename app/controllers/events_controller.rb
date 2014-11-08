require "uri"
require "net/http"
require "json"

class EventsController < ApplicationController

  def trigger
    @type = params[:type]

    # check if it's actually an accident here
    #
    #

    case @type
    when 'accident' # and if it's actually an accident
      sid = YAML.load_file('config/secrets.yml')['twilio']['sid']
      secret = YAML.load_file('config/secrets.yml')['twilio']['token']
      num = YAML.load_file('config/secrets.yml')['twilio']['number']
      twilio_client = Twilio::REST::Client.new sid, secret

      secret = YAML.load_file('config/secrets.yml')['toyota']['secret']

      params =  {
        developerkey: secret,
        responseformat: 'json',
        userid: 'ITCUS_USERID_092'
      }
      x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetUserInfo'), params)
      @user_info = x.body

      @user_info = JSON.parse(@user_info)
      sex = @user_info["vehicleinfo"][0]["sex"]
      age = @user_info["vehicleinfo"][0]["age"]
      vehiclemodel = @user_info["vehicleinfo"][0]["vehiclemodel"]

      params = {
        developerkey: secret,
        responseformat: 'json',
        vehiclemodel: vehiclemodel
      }

      x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetVehicleSpec'), params)
      @vehicle_model_info = x.body

      params = {
        developerkey: secret,
        responseformat: 'json',
        userid: 'ITCJP_USERID_038',
        infoids: '[Posn]'
      }

      x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetVehicleInfo'), params)
      @other_info = x.body

      @other_info = JSON.parse(@other_info)

      lat = @other_info["vehicleinfo"][0]["data"][0]["Posn"]["lat"]
      lon = @other_info["vehicleinfo"][0]["data"][0]["Posn"]["lon"]

      twilio_client.account.sms.messages.create(
        from: "#{num}",
        to: "+17327663590",
        body: "An accident has occurred at " + lat.to_s + ", " + lon.to_s + ". The driver is " + sex.to_s + ", age " + age.to_s + ", driving a " + vehiclemodel.to_s
        )

      Notifier.trigger_response("ajng21@gmail.com").deliver
    end

    render nothing: true
  end

  def test_post
    secret = YAML.load_file('config/secrets.yml')['toyota']['secret']

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

    params = {
      developerkey: secret,
      responseformat: 'json',
      userid: 'ITCJP_USERID_038',
      infoids: '[Posn]'
    }

    x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetVehicleInfo'), params)
    @other_info = x.body

    render json: [@user_info, @vehicle_info, @other_info]
  end
end
