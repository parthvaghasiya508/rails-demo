namespace :maintenance do
  desc "Queue users for removal"
  task :queue_users_for_removal => :environment do
    # Queue users for removal due to inactivity
    # Note! settings.maintenance.remove_old_users
    # must still be enabled, this only bypasses
    # scheduling to run the queuing immediately
    Workers::QueueUsersForRemoval.perform_async
  end
end
