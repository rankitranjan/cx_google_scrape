class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    @search = params[:q]
    @keywords = nil
    @keywords = current_user.keywords.includes(:search_result).where("name ILIKE ?", "%#{params[:q]}%").includes(:search_result).order(created_at: :desc).page(params[:page] || 1).per(8) if current_user
  end
end
