class TraintypesController < ApplicationController
  before_filter :admin_user # nur für administrator
  def index
    @traintypes = Traintype.all
  end

  def show
    @traintype = Traintype.find(params[:id])
  end

  def new
    @traintype = Traintype.new
  end

  def edit
    @traintype = Traintype.find(params[:id])
  end

  def create
    @traintype = Traintype.new(traintype_params)
    if @traintype.save
      flash[:success] = "Zugtyp erfolgreich erstellt"
      redirect_to @traintype
    else
      render :new
    end
  end

  def update
    @traintype = Traintype.find(params[:id])
    if @traintype.update_attributes(traintype_params)
      flash[:success] = "Zugtyp erfolgreich bearbeitet"
      redirect_to @traintype
    else
      render :edit
    end
  end

  def destroy
    Traintype.find(params[:id]).destroy
    flash[:success] = "Zugtyp wurde gelöscht"
    redirect_to traintypes_url
  end

  private
    def traintype_params
      params.require(:traintype).permit(:name)
    end
end
