class HomeController < ApplicationController
  def show
    @developers = developers.limit(10)
  end

  private

  def developers
    Developer.looking_for_work.available.most_recently_added.with_attached_avatar
  end
end
