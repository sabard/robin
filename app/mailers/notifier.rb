class Notifier < ActionMailer::Base
  default from: "alert@robin.com"

  def trigger_response(email, userinfo)
    mail(to: email,
      subject: 'ACCIDENT ALERT!')
  end
end
