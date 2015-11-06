class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :are_we_open
  helper_method :set_open
  helper_method :ensure_admin
  helper_method :get_nice_time_str

  def current_user
    return nil if session[:user_id].nil?
    return nil if UserLogIn.logged_in.find_by(user_id: session[:user_id]).nil?
    User.find(session[:user_id])
  end

  def get_nice_time_str(time)
    diff = (Time.now - time).to_i.abs

    if diff < 60
      "A moment ago"
    elsif diff < 60 * 60
      (diff / 60).floor.to_s + ' minute'.pluralize + ' ago'
    elsif diff < 60 * 60 * 24
      (diff / (60 * 60)).floor.to_s + ' hour'.pluralize + ' ago'
    elsif diff < 60 * 60 * 24 * 31
      (diff / (60 * 60 * 24)).floor.to_s + ' day'.pluralize + ' ago'
    elsif diff < 60 * 60 * 24 * 365
      if Time.now.day - time.day < 0
        (Time.now.month - time.month - 1).abs.to_s + ' month'.pluralize + ' ago'
      else
        (Time.now.month - time.month).abs.to_s + ' month'.pluralize + ' ago'
      end
    else
      'Over a year ago'
    end
  end

  def check_service
    if !are_we_open and !current_user.nil? and !ensure_admin
      user = User.find_by(id: session[:user_id])

      uli = UserLogIn.where(user: user).order(created_at: :desc).first
      unless uli.nil? and uli.logout_time.nil?
        uli.logout_time = Time.now
        uli.save
      end

      UserLogIn.where(user: user).where.not(id: uli.id).each do |u|
        u.delete
      end

      reset_session
      redirect_to :root, notice: "Service under maintenance!"
    end
  end

  def are_we_open
    Rails.application.config.open
  end

  def set_open(whether)
    Rails.application.config.open = whether
  end

  def ensure_admin
    if current_user.nil?
      false
    else
        current_user.admin?
    end
  end

  def toggle_maintenance
    set_open(!Rails.application.config.open)

    if !Rails.application.config.open
      notice = 'Maintenance mode ON, only admin logins are allowed.'
    else
      notice = 'Maintenance mode OFF.'
    end

    redirect_to :back, notice: notice
  end
end