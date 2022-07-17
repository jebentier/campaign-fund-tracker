# frozen_string_literal: true

class DeclareSchemaMigration5 < (ActiveRecord::Migration[4.2])
  def self.up
    create_table :data_sources do |t|
      t.string   :name, limit: 255, null: false
      t.string   :promo, limit: 255, null: false
      t.string   :logo, limit: 1024, null: false
      t.string   :url, limit: 1024, null: false
      t.text     :metadata, limit: nil, null: false, default: "{}"
      t.datetime :created_at, null: true
      t.datetime :updated_at, null: true
    end


    add_column :operating_expenses, :created_at, :datetime, null: true

    add_column :operating_expenses, :updated_at, :datetime, null: true

    add_column :operating_expenses, :data_source_id, :integer, limit: 8, null: false

    add_column :contributions, :created_at, :datetime, null: true

    add_column :contributions, :updated_at, :datetime, null: true

    add_column :contributions, :data_source_id, :integer, limit: 8, null: false

    add_column :committees, :created_at, :datetime, null: true

    add_column :committees, :updated_at, :datetime, null: true

    add_column :committees, :data_source_id, :integer, limit: 8, null: false

    add_column :candidates, :created_at, :datetime, null: true

    add_column :candidates, :updated_at, :datetime, null: true

    add_column :candidates, :data_source_id, :integer, limit: 8, null: false

    change_column :operating_expenses, :candidate_id, :integer, limit: nil, null: false

    add_index :operating_expenses, [:data_source_id], name: :operating_expenses_on_data_source_id

    add_index :contributions, [:data_source_id], name: :contributions_on_data_source_id

    add_index :committees, [:data_source_id], name: :committees_on_data_source_id

    add_index :candidates, [:data_source_id], name: :candidates_on_data_source_id
  end

  def self.down
    remove_index :candidates, name: :candidates_on_data_source_id

    remove_index :committees, name: :committees_on_data_source_id

    remove_index :contributions, name: :contributions_on_data_source_id

    remove_index :operating_expenses, name: :operating_expenses_on_data_source_id

    change_column :operating_expenses, :candidate_id, :integer, null: false

    remove_column :candidates, :data_source_id

    remove_column :candidates, :updated_at

    remove_column :candidates, :created_at

    remove_column :committees, :data_source_id

    remove_column :committees, :updated_at

    remove_column :committees, :created_at

    remove_column :contributions, :data_source_id

    remove_column :contributions, :updated_at

    remove_column :contributions, :created_at

    remove_column :operating_expenses, :data_source_id

    remove_column :operating_expenses, :updated_at

    remove_column :operating_expenses, :created_at

    drop_table :data_sources
  end
end
