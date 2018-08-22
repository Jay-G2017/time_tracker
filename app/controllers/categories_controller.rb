class CategoriesController < ApplicationController
  def new
    @category = Category.new

    render partial: 'new'
  end

  def create
    category = Category.new(category_params)
    category.user = current_user
    category.save!
    
    render partial: 'projects/category', locals: { category: category}
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

end
