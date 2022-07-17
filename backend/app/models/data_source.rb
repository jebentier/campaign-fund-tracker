# frozen_string_literal: true

require_relative 'base'

class DataSource < Base
  declare_schema id: :integer do
    string :name,  limit: 255,  null: false, vaidates: { presence: true }
    string :promo, limit: 255,  null: false, vaidates: { presence: true }
    string :logo,  limit: 1024, null: false, vaidates: { presence: true }
    string :url,   limit: 1024, null: false, vaidates: { presence: true }
    text   :metadata,           null: false, vaidates: { presence: true }, default: "{}"

    timestamps
  end

  has_many :candidates,         class_name: "Candidate",        as: :data_source
  has_many :committees,         class_name: "Committee",        as: :data_source
  has_many :operating_expenses, class_name: "OperatingExpense", as: :data_source
  has_many :contributions,      class_name: "Contribution",     as: :data_source
end
