# See https://github.com/nov/openid_connect_sample/blob/master/app/models/pairwise_pseudonymous_identifier.rb

module Api
  module OpenidConnect
    class PairwisePseudonymousIdentifier < ActiveRecord::Base
      self.table_name = "ppid"

      belongs_to :o_auth_application
      belongs_to :user

      validates :user, presence: true
      validates :identifier, presence: true, uniqueness: {scope: :user}
      validates :guid, presence: true, uniqueness: true

      before_validation :setup, on: :create

      private

      def setup
        self.guid = SecureRandom.hex(16)
      end
    end
  end
end
