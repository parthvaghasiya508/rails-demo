class Mention < ActiveRecord::Base
  belongs_to :mentions_container, polymorphic: true
  belongs_to :person
  validates :mentions_container, presence: true
  validates :person, presence: true

  scope :local, -> {
    joins(:person).where.not(people: {owner_id: nil})
  }

  after_destroy :delete_notification

  def delete_notification
    Notification.where(target_type: self.class.name, target_id: id).destroy_all
  end
end
