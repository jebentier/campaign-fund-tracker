# frozen_string_literal: true

require 'graphql'

require_relative 'types/base'
require_relative 'types/committee'
require_relative 'types/contribution'
require_relative 'types/candidate'

require_relative 'resolvers/committees'
require_relative 'resolvers/candidates'

class QueryType < GraphQL::Schema::Object
  implements GraphQL::Types::Relay::Node

  description "The query root of this schema"

  field :committees, resolver: Resolvers::Committees, connection: true
  field :candidates, resolver: Resolvers::Candidates, connection: true
end
