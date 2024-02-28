class ContactsController < ApplicationController

  def show
    @contact = Contact.find_by({ "id" => params["id"] })
    @company = Company.find_by({ "id" => @contact["company_id"] })
    # filter activities by contact and logged-in user (aka "salesperson")
    @activities = Activity.where({ "contact_id" => @contact["id"], "user_id" => session["user_id"] })
  end

  def new
    @company = Company.find_by({ "id" => params["company_id"] })
  end

  def create
    @contact = Contact.new
    @contact["first_name"] = params["first_name"]
    @contact["last_name"] = params["last_name"]
    @contact["email"] = params["email"]
    @contact["phone_number"] = params["phone_number"]
    @contact.save
    redirect_to "/companies/#{@contact["company_id"]}"
  end

  def edit
    @contact = Contact.find_by({ "id" => params["id"] })
    @company = Company.find_by({ "id" => @contact["company_id"] })
  end
  
  def update
    @contact = Contact.find_by({ "id" => params["id"] })

    # only authorize logged-in user to edit contacts
    if User.find_by({ "id" => session["user_id"] }) != nil
      @contact["first_name"] = params["first_name"]
      @contact["last_name"] = params["last_name"]
      @contact["email"] = params["email"]
      @contact["phone_number"] = params["phone_number"]
      @contact["company_id"] = params["company_id"]
      @contact.save
    else
      flash["notice"] = "You must be logged in."
    end
    redirect_to "/contacts/#{@contact["id"]}"
  end
  
  def destroy
    @contact = Contact.find_by({ "id" => params["id"] })

    # only authorize logged-in user to delete contacts
    if User.find_by({ "id" => session["user_id"] }) != nil
      @contact.destroy
      redirect_to "/companies/#{@contact["company_id"]}"
    else
      flash["notice"] = "You must be logged in."
      redirect_to "/contacts/#{@contact["id"]}"
    end
  end

end