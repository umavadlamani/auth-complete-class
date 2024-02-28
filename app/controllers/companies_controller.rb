class CompaniesController < ApplicationController

  def index
    @companies = Company.all
  end

  def show
    @company = Company.find_by({ "id" => params["id"] })
    @contacts = Contact.where({ "company_id" => @company["id"] })
  end

  def new
  end

  def create
    @company = Company.new
    @company["name"] = params["name"]
    @company["city"] = params["city"]
    @company["state"] = params["state"]
    @company.save
    redirect_to "/companies"
  end

  def edit
    @company = Company.find_by({ "id" => params["id"] })
  end

  def update
    @company = Company.find_by({ "id" => params["id"] })

    # only authorize logged-in user to edit companies
    if User.find_by({ "id" => session["user_id"] }) != nil
      @company["name"] = params["name"]
      @company["city"] = params["city"]
      @company["state"] = params["state"]
      @company.save
    else
      flash["notice"] = "You must be logged in."
    end
    redirect_to "/companies/#{@company["id"]}"
  end
  
  def destroy
    @company = Company.find_by({ "id" => params["id"] })

    # only authorize logged-in user to delete companies
    if User.find_by({ "id" => session["user_id"] }) != nil
      @company.destroy
      redirect_to "/companies"
    else
      flash["notice"] = "You must be logged in."
      redirect_to "/companies/#{@company["id"]}"
    end
  end

end