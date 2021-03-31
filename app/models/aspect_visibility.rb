class AspectVisibility < ActiveRecord::Base

  belongs_to :aspect
  validates :aspect, :presence => true

  belongs_to :shareable, :polymorphic => true
  validates :shareable, :presence => true

  validates :aspect, uniqueness: {scope: %i(shareable_id shareable_type)}
end
