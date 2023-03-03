class ChangeDefaultValueToKeywords < ActiveRecord::Migration[7.0]
  def change
    change_column_default :keywords, :status, from: 2, to: 3
  end
end
