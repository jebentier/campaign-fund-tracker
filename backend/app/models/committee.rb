# frozen_string_literal: true

class Committee < ActiveRecord::Base
  declare_schema id: :integer do
    string :name,              null: false, limit: 255, validates: { presence: true }
    string :state,             null: false, limit: 20,  validates: { presence: true }
    string :country,           null: false, limit: 20,  validates: { presence: true }
    string :entity_type,       null: false, limit: 100, validates: { presence: true }, default: "Unknown"
    string :fec_foriegn_key,   null: false, limit: 50,  validates: { presence: true }
  end

  has_many :inbound_contributions,  class_name: "Contribution", as: :destination
  has_many :outbound_contributions, class_name: "Contribution", as: :source
end
