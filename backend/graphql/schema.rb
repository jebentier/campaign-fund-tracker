# frozen_string_literal: true

require 'graphql'
require_relative 'query'

class GraphqlSchema < GraphQL::Schema
  query QueryType
end
