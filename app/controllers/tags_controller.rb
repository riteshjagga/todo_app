class TagsController < ApplicationController

  before_action :set_tag, only: [:show, :update]

  # GET /tags
  def index
    page_params = params[:page]
    items_per_page = params[:items_per_page]

    @tags = Tag.page(page_params).per(items_per_page)
    # @count = Tag.count
    # @tags_response = {"tags" => @tags, "count" => Tag.count}
    # @tags_response = {count: @count, tags: @tags}
    # render json: @tags
    render json: {count: Tag.count, tags: @tags}
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag
    else
      render json: @tag.errors
    end
  end

  # PUT /tags/:id
  def update
    if @tag.update(tag_params)
      render json: @tag
    else
      render json: @tag.errors
    end
  end

  # GET /tags/:id
  def show
    render json: @tag
  end

  # GET /tags/:name/todos
  def todos
    tags = Tag.where(name: /^#{params[:name]}$/i)
    @todos = tags.empty? ? [] : tags.first.todos
    render json: @todos
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end

    def set_tag
      @tag = Tag.find(params[:id])
    end
end
