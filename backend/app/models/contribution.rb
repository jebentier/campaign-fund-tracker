# frozen_string_literal: true

require_relative 'base'

class Contribution < Base
  declare_schema id: :integer do
    float :amount,     null: false, validates: { presence: true }
    date  :donated_on, null: false, validates: { presence: true }
  end

  belongs_to :destination, polymorphic: true
  belongs_to :source,      polymorphic: true
end
