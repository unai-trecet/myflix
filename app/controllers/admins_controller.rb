class AdminsController < ApplicationController

  before_filter :require_user 
  before_filter :ensure_admin

  private

  def ensure_admin
    if !current_user.admin?
      flash[:error] = "You are not allowed to visit this area."
      redirect_to root_path
    end
  end
end