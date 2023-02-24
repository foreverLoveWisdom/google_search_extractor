# frozen_string_literal: true

class AddNotNullConstraintToSearchResult < ActiveRecord::Migration[7.0]
  def change
    change_column_null :search_results, :html, false
    change_column_null :search_results, :total_links, false
    change_column_null :search_results, :total_search_results, false
  end
end
