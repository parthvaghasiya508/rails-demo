describe GettingStartedHelper, :type => :helper do
  before do
    @current_user = alice
  end

  def current_user
    @current_user
  end

  describe "#has_completed_getting_started?" do
    it 'returns true if the current user has completed getting started' do
      @current_user.getting_started = false
      @current_user.save
      expect(has_completed_getting_started?).to be true
    end

    it 'returns false if the current user has not completed getting started' do
      @current_user.getting_started = true
      @current_user.save
      expect(has_completed_getting_started?).to be false
    end
  end
end
