class FoodsController < ApplicationController
  def new
  end

  def show
    @food = Food.new(number: params[:ndbno])
    if @food.errors
      flash[:alert] = @food.errors
      render :new and return
    end
  end

end
