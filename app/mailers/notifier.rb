class Notifier < ActionMailer::Base
  default from: "alert@robin.com"

  def trigger_response(email)
    mail(to: email,
      subject: 'ALERT')
  end
end
