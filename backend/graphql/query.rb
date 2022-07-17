# frozen_string_literal: true

require 'graphql'
require_relative 'types/committee'
require_relative 'types/contribution'
require_relative 'types/candidate'

class QueryType < GraphQL::Schema::Object
  description "The query root of this schema"

  field :committees, [Types::Committee], null: false do
    description 'Get all commitees of the system'

    argument :first,  Integer, required: false, default_value: 10
    argument :offset, Integer, required: false, default_value: 0
    argument :id,     ID,      required: false, default_value: nil
  end

  field :candidates, [Types::Candidate], null: false do
    description 'Get all candidates of the system'

    argument :first,  Integer, required: false, default_value: 10
    argument :offset, Integer, required: false, default_value: 0
    argument :id,     ID,      required: false, default_value: nil
  end

  def committees(first:, offset:, id:)
    if id
      GlobalID.find(id)
    else
      Committee.limit(first).offset(offset)
    end
  end

  def candidates(first:, offset:, id:)
    if id
      GlobalID.find(id)
    else
      Candidate.limit(first).offset(offset)
    end
  end
end
