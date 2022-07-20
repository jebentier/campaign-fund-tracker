# frozen_string_literal: true

class DeclareSchemaMigration4 < (ActiveRecord::Migration[4.2])
  def self.up
    add_column :contributions, :destination_id, :integer, limit: 8, null: false
    
    add_column :contributions, :destination_type, :string, limit: 255, null: false
    
    add_column :contributions, :source_id, :integer, limit: 8, null: false
    
    add_column :contributions, :source_type, :string, limit: 255, null: false
    
    change_column :operating_expenses, :candidate_id, :integer, limit: nil, null: false
    
    add_index :contributions, [:destination_type, :destination_id], name: :on_destination_type_and_destination_id
    
    add_index :contributions, [:source_type, :source_id], name: :on_source_type_and_source_id
    
    remove_index :contributions, name: :contributions_on_committee_id
    
    remove_index :contributions, name: :contributions_on_candidate_id
    
    remove_column :contributions, :candidate_id
    
    remove_column :contributions, :committee_id
  end

  def self.down
    add_column :contributions, :committee_id, :integer, null: false
    
    add_column :contributions, :candidate_id, :integer, null: false
    
    add_index :contributions, [:candidate_id], name: :contributions_on_candidate_id
    
    add_index :contributions, [:committee_id], name: :contributions_on_committee_id
    
    remove_index :contributions, name: :on_source_type_and_source_id
    
    remove_index :contributions, name: :on_destination_type_and_destination_id
    
    change_column :operating_expenses, :candidate_id, :integer, null: false
    
    remove_column :contributions, :source_type
    
    remove_column :contributions, :source_id
    
    remove_column :contributions, :destination_type
    
    remove_column :contributions, :destination_id
  end
end