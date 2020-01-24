# frozen_string_literal: true

# Base Application Controller
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
end
