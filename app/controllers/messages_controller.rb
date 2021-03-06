class MessagesController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :mobile
  respond_to :json, :only => :show

  def create
    conversation = Conversation.find(params[:conversation_id])

    opts = params.require(:message).permit(:text)
    message = current_user.build_message(conversation, opts)

    if message.save
      logger.info "event=create type=message user=#{current_user.diaspora_handle} status=success " \
                  "message=#{message.id} chars=#{params[:message][:text].length}"
      Diaspora::Federation::Dispatcher.defer_dispatch(current_user, message)

      # TODO: can be removed when messages are not relayed anymore
      conversation_owner = conversation.author.owner
      if conversation_owner && conversation_owner != current_user
        remote_subs = conversation.participants.remote.ids
        opts = {subscriber_ids: remote_subs}
        Diaspora::Federation::Dispatcher.defer_dispatch(conversation_owner, message, opts) unless remote_subs.empty?
      end
    else
      flash[:error] = I18n.t('conversations.new_conversation.fail')
    end
    redirect_to conversations_path(:conversation_id => conversation.id)
  end
end
