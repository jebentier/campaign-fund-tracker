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
    field :source,      Types::Committee, null: false
    field :destination, Types::Candidate, null: false
  end
end
