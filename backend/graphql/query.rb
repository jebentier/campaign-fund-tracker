# frozen_string_literal: true

require 'graphql'
require_relative 'types/committee'
require_relative 'types/contribution'
require_relative 'types/candidate'

class QueryType < GraphQL::Schema::Object
  description "The query root of this schema"

  field :committees, [Types::Committee], null: false do
    description 'Get all commitees of the system'

    argument :first,  Integer, required: false
    argument :offset, Integer, required: false
    argument :id,     ID,      required: false
  end

  def committees(first: 10, offset: 0, id: nil)
    if id
      Committee.where(id: id)
    else
      Committee.limit(first).offset(offset)
    end
  end
end
