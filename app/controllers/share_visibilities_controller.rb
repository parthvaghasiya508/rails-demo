class ShareVisibilitiesController < ApplicationController
  before_action :authenticate_user!

  def update
    post = post_service.find!(params[:post_id])
    current_user.toggle_hidden_shareable(post)
    head :ok
  end

  private

  def post_service
    @post_service ||= PostService.new(current_user)
  end
end
