# frozen_string_literal: true

class DeclareSchemaMigration3 < (ActiveRecord::Migration[4.2])
  def self.up
    change_column :operating_expenses, :candidate_id, :integer, limit: nil, null: false
    
    change_column :contributions, :candidate_id, :integer, limit: nil, null: false
    
    change_column :contributions, :committee_id, :integer, limit: nil, null: false
  end

  def self.down
    change_column :contributions, :committee_id, :integer, limit: 8, null: false
    
    change_column :contributions, :candidate_id, :integer, limit: 8, null: false
    
    change_column :operating_expenses, :candidate_id, :integer, limit: 8, null: false
  end
end