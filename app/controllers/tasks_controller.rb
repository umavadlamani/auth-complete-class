class TasksController < ApplicationController
  def index
    # filter tasks by logged-in user
    @tasks = Task.where({ "user_id" => session["user_id"] })
  end

  def create
    # only authorize logged-in user to add tasks
    if User.find_by({ "id" => session["user_id"] }) != nil
      @task = Task.new
      @task["description"] = params["description"]
      # assign logged-in user as task's user
      @task["user_id"] = session["user_id"]
      @task.save
    end
    
    redirect_to "/tasks"
  end

  def destroy
    @task = Task.find_by({ "id" => params["id"] })

    # only authorize logged-in user to delete their own tasks
    if @task["user_id"] == session["user_id"]
      @task.destroy
    end

    redirect_to "/tasks"
  end
end
