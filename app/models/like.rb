class Like < ActiveRecord::Base
  include Diaspora::Federated::Base
  include Diaspora::Fields::Guid
  include Diaspora::Fields::Author
  include Diaspora::Fields::Target

  include Diaspora::Relayable

  has_one :signature, class_name: "LikeSignature", dependent: :delete

  alias_attribute :parent, :target

  class Generator < Diaspora::Federated::Generator
    def self.federated_class
      Like
    end

    def relayable_options
      {:target => @target, :positive => true}
    end
  end

  after_commit :on => :create do
    self.parent.update_likes_counter
  end

  after_destroy do
    self.parent.update_likes_counter
    participation = author.participations.where(target_id: target.id).first
    participation.unparticipate! if participation.present?
  end

  # NOTE API V1 to be extracted
  acts_as_api
  api_accessible :backbone do |t|
    t.add :id
    t.add :guid
    t.add :author
    t.add :created_at
  end
end
