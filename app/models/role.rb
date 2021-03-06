class Role < ActiveRecord::Base
  belongs_to :person

  validates :person, presence: true
  validates :name, uniqueness: {scope: :person_id}
  validates :name, inclusion: {in: %w(admin moderator spotlight)}

  scope :admins, -> { where(name: "admin") }
  scope :moderators, -> { where(name: %w(moderator admin)) }

  def self.is_admin?(person)
    exists?(person_id: person.id, name: "admin")
  end

  def self.add_admin(person)
    find_or_create_by(person_id: person.id, name: "admin")
  end

  def self.moderator?(person)
    moderators.exists?(person_id: person.id)
  end

  def self.add_moderator(person)
    find_or_create_by(person_id: person.id, name: "moderator")
  end

  def self.add_spotlight(person)
    find_or_create_by(person_id: person.id, name: "spotlight")
  end
end
