require "banks_api/shinsei/version"
require "banks_api"
require "banks_api/shinsei/credential_set"
require "banks_api/shinsei/session"

module BanksApi
  module Shinsei
  end
end

BanksApi::Bank.register_bank(:shinsei, BanksApi::Shinsei::Session)
