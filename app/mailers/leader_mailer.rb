class LeaderMailer < ApplicationMailer
  default from: 'from@example.com'

  def leader_mail(user)
    @user = user
    
    mail to: @email, subject: 'チームリーダーの権限はあなたに変更されました。'
  end
end
