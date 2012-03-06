require 'eventually'
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Eventually
end
