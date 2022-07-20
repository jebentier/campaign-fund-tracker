#!/usr/bin/env ruby
# frozen_string_literal: true
# vi: set ft=ruby :

SERVICE_ROOT       = ENV["SERVICE_ROOT"] || File.expand_path(".", __dir__)
DATABASE_FILE_PATH = File.expand_path('./data/sqlite/2022.db', SERVICE_ROOT)

Dir.chdir(SERVICE_ROOT)

require 'sqlite3'
require 'oj'
require 'logger'
require 'falcon/command'
require 'sinatra/base'
require 'sinatra/cors'
require 'async'
require 'console/logger'
require 'rack/contrib'

require_relative "config/environment"
require_relative 'graphql/schema'

module Api
  class << self
    def logger
      @logger ||= Logger.new(STDOUT, Logger::DEBUG)
    end
  end

  class Server < Sinatra::Base
    register Sinatra::Cors

    set :allow_origin,   "http://localhost:8080"
    set :allow_methods,  "GET,HEAD,POST"
    set :allow_headers,  "content-type,if-modified-since"
    set :expose_headers, "location,link"

    use Rack::JSONBodyParser

    post '/graphql' do
      result = GraphqlSchema.execute(
        params[:query],
        variables: params[:variables],
        context: { current_user: nil },
      )
      [200, { "Content-Type" => "application/json" }, Oj.dump(result.to_h)]
    end

    get "/health" do
      response_from_request_with_error do
        [
          200,
          { "Content-Type" => "application/json" },
          Oj.dump({ 'status' => "ok" })
        ]
      end
    end

    private

    def response_from_request_with_error
      yield
    rescue => ex
      Api.logger.error("An error occured: #{ex.class.name} => #{ex.message}\n#{ex.backtrace.join("\n")}")
      [500, { "Content-Type" => 'text/plain' }, "Internal server error"]
    end
  end
end

Console.logger = Api.logger
Async do
  endpoint   = Falcon::Endpoint.parse("http://0.0.0.0:3000")
  app        = Api::Server.new
  middleware = Falcon::Server.middleware(app)

  Async::HTTP::Server.new(middleware, endpoint).run
end

run lambda { |env| [404, {}, "unknown path\n"] } # Bottom of the stack, give 404.
