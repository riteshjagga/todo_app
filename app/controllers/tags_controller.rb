class TagsController < ApplicationController

  before_action :set_tag, only: [:show, :update]

  # GET /tags
  def index
    page_params = params[:page]
    items_per_page = params[:items_per_page]
    name = params[:name]

    @tags = Tag.where(name: /#{name}/i).page(page_params).per(items_per_page)
    # @count = Tag.count
    # @tags_response = {"tags" => @tags, "count" => Tag.count}
    # @tags_response = {count: @count, tags: @tags}
    # render json: @tags
    render json: {count: @tags.count, tags: @tags}
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # PUT /tags/:id
  def update
    if @tag.update(tag_params)
      render json: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # GET /tags/:id
  def show
    render json: @tag
  end

  # GET /tags/:name/todos
  def todos
    page_params = params[:page].presence || 1
    items_per_page = params[:items_per_page].presence || 5

    @todos = Tag.where(name: /^#{params[:name]}$/i).first.todos rescue []
    if @todos.count > 0
      @todos = (params[:deleted]) ? @todos.deleted : @todos.not_deleted
      @todos = @todos.includes(:tags).page(page_params).per(items_per_page)
    end

    render json: {count: @todos.count, todos: @todos.as_json(include: {
            tags: {only: [:_id, :name]}
        })}
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end

    def set_tag
      @tag = Tag.find(params[:id])
    end
end
