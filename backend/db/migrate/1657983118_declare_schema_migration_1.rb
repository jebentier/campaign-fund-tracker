# frozen_string_literal: true

class DeclareSchemaMigration1 < (ActiveRecord::Migration[4.2])
  def self.up
    create_table :candidates do |t|
      t.string :name, limit: 255, null: false
      t.string :state, limit: 20, null: false
      t.string :country, limit: 20, null: false
      t.string :party_afilliation, limit: 100, null: true, default: "Unknown"
      t.string :fec_foriegn_key, limit: 50, null: false
    end
  end

  def self.down
    drop_table :candidates
  end
end
