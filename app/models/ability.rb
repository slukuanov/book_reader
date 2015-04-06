class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == 'admin'
      can :access, :admin
      can :manage, :all
    end
  end
end
