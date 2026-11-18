class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  # GET /tasks
  # GET /tasks?completed=true
  def index
    tasks = Task.filter_by_status(params[:completed]).recent_first
    render json: tasks
  end

  # GET /tasks/:id
  def show
    render json: @task
  end

  # POST /tasks
  def create
    task = Task.new(task_params)

    if task.save
      render json: task, status: :created, location: task
    else
      render json: { errors: task.errors }, status: :unprocessable_content
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors }, status: :unprocessable_content
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy!
    head :no_content
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.expect(task: %i[title description completed])
  end
end
