class TodosController < ApplicationController

  before_action :set_todo, only: [:show, :update, :update_status, :destroy, :undo_delete]

  # GET /todos
  def index
    page_params = params[:page].presence || 1
    items_per_page = params[:items_per_page].presence || 5
    deleted = !!params[:deleted]
    title = params[:title]

    todos_scope = deleted ? Todo.deleted : Todo.not_deleted
    todos_scope = todos_scope.where(title: /#{title}/i) if(!title.nil?)
    todos_count = todos_scope.count

    @todos = todos_scope.includes(:tags).page(page_params).per(items_per_page)

    render json: {count: todos_count, todos: @todos.as_json(include: {
        tags: {only: [:_id, :name]}
    })}
    # @todos_object = {count: Todo.count, todos: @todos}
    # render json: {count: todos_count, todos: @todos.as_json(include: {tags: {only: [:_id, :name]}})}
    # render json: {count: todos_count, todos: @todos}
    # render "todos/index"

  end

  # POST /todos
  def create
    @todo = Todo.create(todo_params)

    if @todo.save
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # GET /todos/:id
  def show
    render json: @todo
  end

  # PUT /todos/:id
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH /todos/:id/update_status
  def update_status
    @todo.status = params[:status]
    if @todo.save
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:id
  def destroy
    @todo.is_deleted = true
    render json: @todo if @todo.save
  end

  # PATCH /todos/:id/undo_delete
  def undo_delete
    @todo.is_deleted = false
    render json: @todo if @todo.save
  end

  private
    def todo_params
      # {"todo"=>{"title"=>"Tag with tags", "tags"=>["5c8a44b38b48f5253b4b7b4c", "5c8a480b8b48f55958516e54"]}, "controller"=>"todos", "action"=>"create"}
      params.require(:todo).permit(:title, :tag_ids => [])
    end

    def set_todo
      @todo = Todo.find(params[:id])
    end
end
