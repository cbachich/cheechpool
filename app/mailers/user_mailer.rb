class UserMailer < ActionMailer::Base
  default from: "cheechdev@gmail.com"

  def smack_email(smack)
    @smack = smack
    mail(to: smack.league.users_emails, subject: "CheechPool: #{smack.user.name} posted smack!")
  end

  def password_reset_email(user,password)
    @user = user
    @password = password
    mail(to: user.email, subject: "Cheechpool: Your password has been reset!")
  end
end
