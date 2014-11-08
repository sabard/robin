class EventsController < ApplicationController
  require 'yaml'

  def trigger
    @type = params[:type]

    case @type
    when 'accident'
      sid = YAML.load_file('config/secrets.yml')['twilio']['sid']
      secret = YAML.load_file('config/secrets.yml')['twilio']['token']
      num = YAML.load_file('config/secrets.yml')['twilio']['number']
      twilio_client = Twilio::REST::Client.new sid, secret
      twilio_client.account.sms.messages.create(
        :from => "#{num}",
        :to => "+17329304455",
        :body => "An accident has occurred!"
      )

      Notifier.trigger_response("sabar.dasgupta@gmail.com").deliver
    end

    render nothing: true
  end
end
