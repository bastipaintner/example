class UsersController < ApplicationController
  before_filter :admin_user # nur für administrator
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
      flash[:success] = "Nutzer erfolgreich erstellt"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Nutzer erfolgreich bearbeitet"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "Nutzer wurde gelöscht"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :admin, :password,
        :password_confirmation)
    end
end
