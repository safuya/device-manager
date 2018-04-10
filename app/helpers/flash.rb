module Flash
  def flash
    session.delete(:flash)
  end

  def errors_to_flash(error_messages)
    session[:flash] = error_messages.map do |key, value|
      "#{key}: #{value}"
    end.join("\n")
  end

  def approvals?
    !User.where(group_id: nil).empty?
  end
end
