class UserMailer < ActionMailer::Base
  default from: "cheechdev@gmail.com"

  def smack_email(smack)
    @smack = smack
    mail(to: smack.league.users_emails, subject: "CheechPool: #{smack.user.name} posted smack!")
  end
end
