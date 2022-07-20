# frozen_string_literal: true

class DeclareSchemaMigration2 < (ActiveRecord::Migration[4.2])
  def self.up
    create_table :operating_expenses do |t|
      t.string  :name, limit: 255, null: false
      t.string  :fec_foriegn_key, limit: 50, null: false
      t.string  :state, limit: 20, null: false
      t.string  :country, limit: 20, null: false
      t.float   :amount, null: false
      t.integer :candidate_id, limit: 8, null: false
    end


    create_table :contributions do |t|
      t.float   :amount, null: false
      t.date    :donated_on, null: false
      t.integer :candidate_id, limit: 8, null: false
      t.integer :committee_id, limit: 8, null: false
    end


    create_table :committees do |t|
      t.string :name, limit: 255, null: false
      t.string :state, limit: 20, null: false
      t.string :country, limit: 20, null: false
      t.string :entity_type, limit: 100, null: false, default: "Unknown"
      t.string :fec_foriegn_key, limit: 50, null: false
    end


    add_index :operating_expenses, [:candidate_id], name: :operating_expenses_on_candidate_id

    add_index :contributions, [:candidate_id], name: :contributions_on_candidate_id

    add_index :contributions, [:committee_id], name: :contributions_on_committee_id

    add_foreign_key :operating_expenses, :candidates, column: :candidate_id, name: :index_operating_expenses_on_candidate_id

    add_foreign_key :contributions, :candidates, column: :candidate_id, name: :index_contributions_on_candidate_id

    add_foreign_key :contributions, :committees, column: :committee_id, name: :index_contributions_on_committee_id
  end

  def self.down
    remove_foreign_key :contributions, name: :index_contributions_on_committee_id

    remove_foreign_key :contributions, name: :index_contributions_on_candidate_id

    remove_foreign_key :operating_expenses, name: :index_operating_expenses_on_candidate_id

    remove_index :contributions, name: :on_committee_id

    remove_index :contributions, name: :on_candidate_id

    remove_index :operating_expenses, name: :on_candidate_id

    drop_table :committees

    drop_table :contributions

    drop_table :operating_expenses
  end
end
