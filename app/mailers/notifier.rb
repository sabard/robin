class Notifier < ActionMailer::Base
  default from: "sabar@chesscademy.com"

  def trigger_response(email)
    mail(to: email, 
      subject: 'ALERT')
  end
end
