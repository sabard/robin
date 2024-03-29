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
    when 'accident'
      if Rails.env.production?
        sid = ENV['TWILIO_SID']
        secret = ENV['TWILIO_SECRET']
        num = ENV['TWILIO_NUM']
      else
        sid = YAML.load_file('config/super_secrets.yml')['twilio']['sid']
        secret = YAML.load_file('config/super_secrets.yml')['twilio']['token']
        num = YAML.load_file('config/super_secrets.yml')['twilio']['number']
      end
      twilio_client = Twilio::REST::Client.new sid, secret
      secret = YAML.load_file('config/super_secrets.yml')['toyota']['secret']

      crashed = false
      
      # determine if crashed happened based on api call
      #start_time = DateTime.parse(params[:timestamp]) - 30.seconds
      #end_time = DateTime.parse(params[:timestamp]) - 30.seconds
      start_time = "2014-11-08 15:00:00"
      end_time = "2014-11-08 15:01:00"

      params = {
        developerkey: secret,
        responseformat: 'json',
        userid: 'ITCJP_USERID_038',
        searchstart: start_time,
        searchend: end_time,
        infoids: '[Spd]'
      }
      x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetVehicleInfo'), params)
      @possible_crash = x.body
      raise @possible_crash.to_yaml

      crashed = true

      if crashed
        # get vehicle position
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

        # get user info
        params =  {
          developerkey: secret,
          responseformat: 'json',
          userid: 'ITCJP_USERID_038'
        }
        x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetUserInfo'), params)
        @user_info = x.body

        @user_info = JSON.parse(@user_info)
        sex = @user_info["vehicleinfo"][0]["sex"]
        age = @user_info["vehicleinfo"][0]["age"]
        usn = @user_info["vehicleinfo"][0]["username"]
        vehiclemodel = @user_info["vehicleinfo"][0]["vehiclemodel"]

        # Pusher
        Pusher['events'].trigger('accident', {
          message: "You have been in an accident, #{usn}! Your location is #{lat} #{lon}. Authorities are on the way and your contacts have been notified"
        })

        # get vehicle specifications
        params = {
          developerkey: secret,
          responseformat: 'json',
          vehiclemodel: vehiclemodel
        }

        x = Net::HTTP.post_form(URI.parse('https://api-jp-t-itc.com/GetVehicleSpec'), params)
        @vehicle_model_info = x.body

=begin
        twilio_client.account.sms.messages.create(
          from: "#{num}",
          to: "+17327663590",
          body: "An accident has occurred at " + lat.to_s + ", " + lon.to_s + ". The driver is " + sex.to_s + ", age " + age.to_s + ", driving a " + vehiclemodel.to_s
          )

        Notifier.trigger_response("ajng21@gmail.com").deliver
=end
      end
    end

    render nothing: true
  end

  def test_post
    if Rails.env.production?
      secret = ENV['SECRET']
    else
      secret = YAML.load_file('config/super_secrets.yml')['toyota']['secret']
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
