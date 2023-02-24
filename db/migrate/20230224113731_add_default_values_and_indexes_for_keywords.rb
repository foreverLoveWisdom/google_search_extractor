# frozen_string_literal: true

class AddDefaultValuesAndIndexesForKeywords < ActiveRecord::Migration[7.0]
  def change
    change_column_default :keywords, :status, from: nil, to: 2
    add_index :keywords, :status
    add_index :keywords, :name
    change_column_null :keywords, :name, false
  end
end
