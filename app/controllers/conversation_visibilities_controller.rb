class ConversationVisibilitiesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @vis = ConversationVisibility.where(:person_id => current_user.person.id,
                                        :conversation_id => params[:conversation_id]).first
    if @vis
      participants = @vis.conversation.participants.count
      if @vis.destroy
        if participants == 1
          flash[:notice] = I18n.t('conversations.destroy.delete_success')
        else
          flash[:notice] = I18n.t('conversations.destroy.hide_success')
        end
      end
    end
    redirect_to conversations_path
  end
end
