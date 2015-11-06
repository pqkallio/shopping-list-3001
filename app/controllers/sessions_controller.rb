class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by username: params[:username]
    if user and user.authenticate(params[:password])
      if !are_we_open and !user.admin
        redirect_to :root, notice: 'Maintenance, go away!'
      else
        session[:user_id] = user.id
        UserLogIn.create user: user
        redirect_to user
      end
    else
      redirect_to :back, notice: 'Invalid username or password!'
    end
  end

  def destroy
    user = User.find_by(id: session[:user_id])
    logout_user(user)

    reset_session
    redirect_to :root
  end

  def delete_all
    notice = 'Illegal action'
    if current_user.admin
      Session.each do |s|
        unless User.find_by(id: s[:user_id]).admin
          s.delete
        end
      end

      User.each do |u|
        unless u.admin
          logout_user(u)
        end
      end
      notice = 'All except admin-sessions terminated successfully'
    end

    redirect_to :back, notice: notice
  end

  private

  def logout_user(user)
    uli = UserLogIn.where(user: user).order(created_at: :desc).first
    unless uli.nil? and uli.logout_time.nil?
      uli.logout_time = Time.now
      uli.save
    end

    UserLogIn.where(user: user).where.not(id: uli.id).each do |u|
      u.delete
    end
  end

end