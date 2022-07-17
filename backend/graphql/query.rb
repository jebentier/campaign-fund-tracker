# frozen_string_literal: true

require 'graphql'
require_relative 'types/committee'
require_relative 'types/contribution'
require_relative 'types/candidate'

class QueryType < GraphQL::Schema::Object
  implements GraphQL::Types::Relay::Node

  description "The query root of this schema"

  field :node,  Types::LegalEntityInterface, null: false do
    argument :id, ID, required: true
  end

  field :committees, [Types::Committee], null: false do
    description 'Get all commitees of the system'

    argument :first,  Integer, required: false, default_value: 10
    argument :offset, Integer, required: false, default_value: 0
  end

  field :candidates, [Types::Candidate], null: false do
    description 'Get all candidates of the system'

    argument :first,  Integer, required: false, default_value: 10
    argument :offset, Integer, required: false, default_value: 0
  end

  def node(id:)
    GlobalID.find(id)
  end

  def committees(first:, offset:)
    Committee.limit(first).offset(offset)
  end

  def candidates(first:, offset:)
    Candidate.limit(first).offset(offset)
  end
end
