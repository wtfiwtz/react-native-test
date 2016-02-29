module ApplicationHelper

  def user_avatar(user)
    user.avatar.present? ? user.avatar.url : '/img/avatar.gif'
  end
end
