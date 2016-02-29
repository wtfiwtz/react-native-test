class User < ActiveRecord::Base

  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  # Associations
  has_one :authentication
  has_one :website

  def to_s
    "#{first_name} #{last_name}"
  end

  def contact_details
    # TODO: contact details in Admin interface
    email
  end
end
