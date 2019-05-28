class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy change]
  before_action :not_owner, only: %i[edit update]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: 'チーム作成に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :new
    end
  end

  def update
    @team.owner_id == current_user.id
    if @team.update(team_params)
      redirect_to @team, notice: 'チーム更新に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :edit
    end
  end

  def destroy
    if @team.owner_id == current_user.id
      @team.destroy
      redirect_to teams_url, notice: 'チーム削除に成功しました！'
    else
      redirect_to teams_path, notice: "権限がありません"
    end
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end
  
  def change
    @team.owner_id = params[:owner_id]
    if @team.save
      @user = User.find(params:[:owner_id])
      LeaderMailer.leader_mail(@user).deliver
      redirect_to team_url(params[:id])
    else
      redirect_to team_url(params[:id])
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
  
  def not_owner
    redirect_to team_path, notice:"チームのオーナーではありません！" unless current_user == @team.owner
  end
  
end
