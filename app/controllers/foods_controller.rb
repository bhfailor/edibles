class FoodsController < ApplicationController
  def new
  end

  def show
    @food = Food.new(number: params[:ndbno])
    redirect_to({ action: 'new' }, alert: @food.errors) if @food.errors
  end
end
