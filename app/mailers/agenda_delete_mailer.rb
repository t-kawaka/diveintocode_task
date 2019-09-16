class AgendaDeleteMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_delete_mail(agenda, team_member)
    @agenda = agenda
    @user = team_member.user
    mail to: @user.email, subject: '【お知らせ】アジェンダが削除されました'
  end
end
