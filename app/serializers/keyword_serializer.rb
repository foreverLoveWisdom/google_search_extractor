# frozen_string_literal: true

# Serializer for Keyword model
class KeywordSerializer
  include JSONAPI::Serializer

  attributes :name, :status
end
