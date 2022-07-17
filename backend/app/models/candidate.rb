# frozen_string_literal: true

require_relative 'base'

class Candidate < Base
  declare_schema id: :integer do
    string :name,              null: false, limit: 255, validates: { presence: true }
    string :state,             null: false, limit: 20,  validates: { presence: true }
    string :country,           null: false, limit: 20,  validates: { presence: true }
    string :party_afilliation, null: true,  limit: 100, default: "Unknown"
    string :fec_foriegn_key,   null: false, limit: 50,  validates: { presence: true }

    timestamps
  end

  belongs_to :data_source

  has_many :inbound_contributions,  class_name: "Contribution", as: :destination
  has_many :outbound_contributions, class_name: "Contribution", as: :source
  has_many :operating_expenses
end
