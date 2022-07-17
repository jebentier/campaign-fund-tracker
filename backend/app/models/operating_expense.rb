# frozen_string_literal: true

require_relative 'base'

class OperatingExpense < Base
  declare_schema id: :integer do
    string :name,            limit: 255, null: false, validates: { presence: true }
    string :fec_foriegn_key, limit: 50,  null: false, validates: { presence: true }
    string :state,           limit: 20,  null: false, validates: { presence: true }
    string :country,         limit: 20,  null: false, validates: { presence: true }
    float  :amount,                      null: false, validates: { presence: true }

    timestamps
  end

  belongs_to :data_source

  belongs_to :candidate
end
