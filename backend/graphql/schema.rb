# frozen_string_literal: true

require 'graphql'
require_relative 'query'

class GraphqlSchema < GraphQL::Schema
  query QueryType

  orphan_types [Types::Committee, Types::Candidate]
  default_page_size     10
  default_max_page_size 100

  class << self
    def resolve_type(type, obj, ctx)
      case obj
      when Committee
        Types::Committee
      when Candidate
        Types::Candidate
      when Contribution
        Types::Contribution
      else
        raise "Unexpected object: #{obj}"
      end
    end

    def id_from_object(object, type_definition, query_ctx)
      # Generate a unique string ID for `object` here
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      object.to_gid_param
    end

    def object_from_id(global_id, query_ctx)
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      GlobalID.find(global_id)
    end
  end
end
