describe Workers::DeleteAccount do
  describe '#perform' do
    it 'performs the account deletion' do
      account_deletion = double
      allow(AccountDeletion).to receive(:find).and_return(account_deletion)
      expect(account_deletion).to receive(:perform!)
      
      Workers::DeleteAccount.new.perform(1)
    end
  end
end
