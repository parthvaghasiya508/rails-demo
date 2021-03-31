module GettingStartedHelper
  # @return [Boolean] The user has completed all steps in getting started
  def has_completed_getting_started?
    current_user.getting_started == false
  end
end
