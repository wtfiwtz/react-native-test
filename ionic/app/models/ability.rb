class Ability
  include CanCan::Ability

  def initialize(user)

    # Public information
    can :read, User
    can :read, Website
    can :read, Folder
    can :read, Collection
    can :read, Item

    # Users can update their own information
    can [:update], User, :id => user.id if user.present?

  end
end
