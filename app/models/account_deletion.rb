class AccountDeletion < ActiveRecord::Base
  include Diaspora::Federated::Base

  scope :uncompleted, -> { where('completed_at is null') }

  belongs_to :person
  after_commit :queue_delete_account, :on => :create

  def person=(person)
    self[:diaspora_handle] = person.diaspora_handle
    self[:person_id] = person.id
  end

  def diaspora_handle=(diaspora_handle)
    self[:diaspora_handle] = diaspora_handle
    self[:person_id] ||= Person.find_by_diaspora_handle(diaspora_handle).id
  end

  def queue_delete_account
    Workers::DeleteAccount.perform_async(self.id)
  end

  def perform!
    Diaspora::Federation::Dispatcher.build(person.owner, self).dispatch if person.local?
    AccountDeleter.new(diaspora_handle).perform!
  end

  def subscribers
    person.owner.contact_people.remote | Person.who_have_reshared_a_users_posts(person.owner).remote
  end

  def public?
    true
  end
end
