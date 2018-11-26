class CategoriesController < ApplicationController
  def new
    @category = Category.new

    render partial: 'new'
  end

  def show
    category = Category.find params[:id]
    @projects = category.projects

    render partial: 'show'
  end

  def edit
    @category = Category.find params[:id]

    render partial: 'edit'
  end

  def update
    category = Category.find params[:id]
    category.update!(category_params)

    render json: category
  end

  def create
    category = Category.new(category_params)
    category.user = current_user
    category.save!

    render partial: 'show', locals: { category: category}
  end

  def destroy
    category = Category.find params[:id]
    undone_projects_count = category.undone_projects.count
    starred_projects_count = category.starred_projects.count
    category.destroy!

    render json: { success: true, undone_projects_count:  undone_projects_count, starred_projects_count: starred_projects_count }
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

end
