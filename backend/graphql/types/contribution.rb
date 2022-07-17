# frozen_string_literal: true

require 'graphql'
require_relative 'base'

module Types
  class Committee < Base; end
  class Candidate < Base; end

  class Contribution < Base
    description 'Resembels a contribution made from a committee to a candidate'

    field :amount,      Float,   null: false
    field :donated_on,  Integer, null: false
    field :source,      Types::LegalEntityInterface, null: false
    field :destination, Types::LegalEntityInterface, null: false
  end
end
