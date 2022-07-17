# frozen_string_literal: true

require_relative 'base'

class Contribution < Base
  declare_schema id: :bigint do
    float :amount,     null: false, validates: { presence: true }
    date  :donated_on, null: false, validates: { presence: true }

    timestamps
  end

  belongs_to :data_source

  belongs_to :destination, polymorphic: true
  belongs_to :source,      polymorphic: true
end
