# frozen_string_literal: true

require 'globalid'

class Base < ActiveRecord::Base
  include GlobalID::Identification

  self.abstract_class = true
end
