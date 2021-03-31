require "uri"

module Api
  module OpenidConnect
    class IdToken
      def initialize(authorization, nonce)
        @authorization = authorization
        @nonce = nonce
        @created_at = Time.current
        @expires_at = 30.minutes.from_now
      end

      def to_jwt(options={})
        to_response_object(options).to_jwt(OpenidConnect::IdTokenConfig::PRIVATE_KEY) do |jwt|
          jwt.kid = :default
        end
      end

      private

      def to_response_object(options={})
        OpenIDConnect::ResponseObject::IdToken.new(claims).tap do |id_token|
          id_token.code = options[:code] if options[:code]
          id_token.access_token = options[:access_token] if options[:access_token]
        end
      end

      def claims
        sub = build_sub
        @claims ||= {
          iss:       Rails.application.routes.url_helpers.root_url,
          sub:       sub,
          aud:       @authorization.o_auth_application.client_id,
          exp:       @expires_at.to_i,
          iat:       @created_at.to_i,
          auth_time: @authorization.user.current_sign_in_at.to_i,
          nonce:     @nonce,
          acr:       0
        }
      end

      def build_sub
        Api::OpenidConnect::SubjectIdentifierCreator.create(@authorization)
      end
    end
  end
end
