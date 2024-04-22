require 'active_support/concern'
require 'openssl'

# Token Authenticator
module TokenAuthenticator
  extend ActiveSupport::Concern

  def token_authenticate(params, token)
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('SHA256'), params, token)
    Base64.strict_encode64(hash)
  end
end
