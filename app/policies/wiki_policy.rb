class WikiPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def set_for_standard_or_guest
      all_wikis = scope.all
      wikis = []
      all_wikis.each do |wiki|
        if wiki.private == false || (!user.nil? && wiki.collaborators.exists?(user_id: user.id))
          wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
        end
      end
      wikis
    end

    def resolve
      wikis = []
      if user.nil?
        wikis = set_for_standard_or_guest
      elsif user.role == 'admin'
        wikis = scope.all # if the user is an admin, show them all the wikis
      elsif user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if wiki.private == false || wiki.user == user || wiki.collaborators.exists?(user_id: user.id)
            wikis << wiki # if the user is premium, only show them public wikis, or that private wikis they created, or private wikis they are a collaborator on
          end
        end
      else # this is the lowly standard user
        wikis = set_for_standard_or_guest
      end
      wikis # return the wikis array we've built up
    end
  end

  def update?
    user.present?
  end
end
