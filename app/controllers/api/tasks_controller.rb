class Api::TasksController < ApplicationController
  protect_from_forgery

  def index
    tasks = Task.order('updated_at DESC')
    render :json => {tasks: tasks}
  end

  def create
    task = Task.new(task_params)

    if task.save
      render :json => {task: task}, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    task = Task.find(params[:id])
    if task.update(task_params)
      render :json => {task: task}, status: :ok
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    render json: task
  end

  private

  def task_params
    params.fetch(:task, {}).permit(:name, :is_done)
  end
end
