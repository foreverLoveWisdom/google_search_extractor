# frozen_string_literal: true

# Serializer for User model
class UserSerializer
  include JSONAPI::Serializer

  attributes :email, :authentication_token
end
