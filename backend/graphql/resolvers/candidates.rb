# frozen_string_literal: true

require 'graphql'

require_relative '../types/base'
require_relative '../types/candidate'

module Resolvers
  class Candidates < GraphQL::Schema::Resolver
    type Types::Candidate.connection_type, null: false

    argument :search_string, String, required: false

    def resolve(search_string: nil)
      if search_string
        Candidates.where('name ILIKE ?', "%#{search_string}%")
      else
        Candidates.all
      end
    end
  end
end
