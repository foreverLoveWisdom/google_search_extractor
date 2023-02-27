# frozen_string_literal: true

# Serializer for SearchResult model
class SearchResultSerializer
  include JSONAPI::Serializer

  attributes :adwords_advertisers,
             :total_links,
             :total_search_results,
             :html
end
