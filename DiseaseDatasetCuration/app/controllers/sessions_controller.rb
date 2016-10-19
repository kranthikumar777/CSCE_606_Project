class SessionsController < ApplicationController

  def new
  end

  def create
    if params[:session].nil?||params[:session][:email].nil?
      user = User.from_omniauth(env["omniauth.auth"])
      if user
        session[:user_id] = user.id
        redirect_to '/profile'
        return
      end
    end
   
    
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user

      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # redirect_to user

      if user.admin?
        redirect_to '/admin'
      else
        redirect_to '/profile'
      end
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
