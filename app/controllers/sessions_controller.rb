class SessionsController < ApplicationController
  def new
    # render login form in sessions/new.html.erb
  end

  def create
    # authenticate the user
    # 1. try to find the user by their unique identifier
    @user = User.find_by({ "email" => params["email"] })
    # 2. if the user exists -> check if they know their password
    if @user != nil
      # 3. if they know their password -> login is successful
      if BCrypt::Password.new(@user["password"]) == params["password"]
        session["user_id"] = @user["id"]
        flash["notice"] = "Welcome, #{@user["first_name"]}."
        redirect_to "/companies"
      else
        # 4b. if the user doesn't know their password -> login fails
        flash["notice"] = "Nope."
        redirect_to "/login"
      end
    else
      # 4a. if the user doesn't exist -> login fails
      flash["notice"] = "Nope."
      redirect_to "/login"
    end
  end

  def destroy
    # logout the user
    flash["notice"] = "Goodbye."
    session["user_id"] = nil
    redirect_to "/login"
  end
end
