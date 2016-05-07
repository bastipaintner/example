################################################################################
# controller for trains                                                        #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/controllers/trains_controller.rb                                   #
################################################################################
class TrainsController < ApplicationController
  before_filter :admin_user # only accessible for admin
  def index
    @trains = Train.all
  end

  def show
    @train = Train.find params[:id]
  end

  def new
    @train = Train.new
  end

  def edit
    @train = Train.find params[:id]
  end

  def create
    @train = Train.new train_params
    if @train.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @train = Train.find params[:id]
    if @train.update_attributes train_params
      flash[:success] = "Zug erfolgreich bearbeitet"
      redirect_to @train
    else
      render :edit
    end
  end

  def destroy
    Train.find(params[:id]).destroy
    flash[:success] = "Zugtyp wurde gelöscht"
    redirect_to trains_url
  end

  private
    def train_params
      params.require(:train).permit :name, :traintype_id
    end
end
