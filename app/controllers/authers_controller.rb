class AuthersController < ApplicationController
  def index
    @authers = Auther.all
  end

  
  def new
    @auther = AuthersForm.new
  end

  def create
    @auther = AuthersForm.new(auther_params)
    if @auther.save
      redirect_to authers_path
    else
      render 'new'
    end
  end

  def edit
    @auther = AuthersForm.find(params[:id])
  end

  def update
    @auther = AuthersForm.find(params[:id])
    if @auther.update(auther_params)
      redirect_to authers_path
    else
      render 'edit'
    end
  end

  def destroy

  end

  private
  
  def auther_params
    params.require(:authers_form).permit(:name, :sex,
                                         books_attributes: [:name, :page, :id,
                                                            :auther_id])
  end
end
