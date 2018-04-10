module Authorization
  def only_admins
    unauthorized unless admin?
  end

  def only_current_user_or_admin
    unauthorized unless current_user? || admin?
  end

  def only_current_user
    unauthorized unless current_user?
  end

  def only_approved
    unauthorized unless approved?
  end

  def unauthorized
    halt erb :'errors/401'
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def admin?
    approved? && current_user.group.privilege == 'admin'
  end

  def current_user?
    logged_in? && current_user.id == params[:id].to_i
  end

  def approved?
    logged_in? && !current_user.group.blank?
  end

  def not_approved?
    logged_in? && current_user.group.blank?
  end
end
