module Workers
  class DeleteAccount < Base
    sidekiq_options queue: :low
    
    def perform(account_deletion_id)
      account_deletion = AccountDeletion.find(account_deletion_id)
      account_deletion.perform!
    end
  end
end
