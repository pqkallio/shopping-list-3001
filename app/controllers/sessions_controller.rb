class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by username: params[:username]
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      UserLogIn.create user: user
      redirect_to user
    else
      redirect_to :back
    end
  end

  def destroy
    uli = UserLogIn.find_by(user_id: session[:user_id], logout_time: nil)
    if uli
      uli.logout_time = DateTime.now
      uli.save
    end
    session[:user_id] = nil
    redirect_to :root
  end

end