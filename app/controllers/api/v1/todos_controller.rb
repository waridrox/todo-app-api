class Api::V1::TodosController < ApplicationController
  before_action :set_todo, only: %i[show, update, destroy]

  # GET /todos
  def index
    @todos = Todo.all
    limit = params[:_limit]

    # if a limit is present then filter out the todos in the reverse order of their ids
    if limit.present?
      limit = limit.to_i
      @todos = @todos.last(limit)
    end
    render json: @todos.reverse
  end

  # GET /todos/1
  def show
    render json: @todo = Todo.find(params[:id])
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render json: @todo, status: :created, location: api_v1_todos_path(@todo)
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    if ((Todo.find(params[:id])))
      @todo = Todo.find(params[:id])
      @todo.update!(todo_params)
      render json: @todo
    else 
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:id, :title, :completed, :_limit)
    end
end
