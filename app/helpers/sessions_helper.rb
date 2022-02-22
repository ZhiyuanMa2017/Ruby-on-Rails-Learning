module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  def student_logged_in?
    !current_user.nil? && !current_user.teacher && !current_user.admin
  end

  def teacher_logged_in?
    !current_user.nil? && current_user.teacher
  end

  def admin_logged_in?
    !current_user.nil? && current_user.admin
  end

  def log_out
    session.delete(:user_id)
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def current_user?(user)
    user == current_user
  end

end
