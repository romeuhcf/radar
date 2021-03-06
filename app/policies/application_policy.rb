class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists? && related?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  protected
  def related?
    (admin? or record.owner == user)
  end

  def admin?
    user.has_role?(:admin)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  protected
  def related?
    (user.has_role?(:admin) or record.owner == user)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
