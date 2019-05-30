class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if Assign.where(user_id: current_user.id).where(team_id: @agenda.team.id).present? && current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      redirect_to dashboard_url, notice: 'アジェンダ作成に失敗しました！アジェンダは2文字〜20文字で作成お願いします!'
    end
  end
  
  def destroy
    if @agenda.user_id == current_user.id || @agenda.team.owner_id == current_user.id 
      team_id = @agenda.team_id
      @users = Assign.where(team_id: team_id).all
      @users.each do |user|
        AgendaDeleteMailer.agenda_delete_mail(@agenda, user).deliver
      end
      @agenda.destroy
      redirect_to dashboard_url, notice: "アジェンダを削除しました"
    else
      redirect_to dashboard_url, notice:"削除権限がありません。"
    end
  end

  private

  def set_agenda
    if Agenda.find_by(id:params[:id])
      @agenda = Agenda.find(params[:id])
    else
      redirect_to dashboard_url, notice:"見つかりませんでした"
    end
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
