# frozen_string_literal: true

require 'graphql'

require_relative '../types/base'
require_relative '../types/committee'

module Resolvers
  class Committees < GraphQL::Schema::Resolver
    type Types::Committee.connection_type, null: false

    argument :search_string, String, required: false

    def resolve(search_string: nil)
      if search_string
        Committee.where('name ILIKE ?', "%#{search_string}%")
      else
        Committee.all
      end
    end
  end
end
