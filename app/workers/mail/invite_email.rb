module Workers
  module Mail
    class InviteEmail < Base
      sidekiq_options queue: :low

      def perform(emails, inviter_id, options={})
        EmailInviter.new(emails, User.find(inviter_id), options).send!
      end
    end
  end
end
