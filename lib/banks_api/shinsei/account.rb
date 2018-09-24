module BanksApi
  module Shinsei
    class Account
      attr_reader :id, :type, :description, :currency, :balance, :base_balance

      def initialize(id:, type:, description:, currency:, balance:, base_balance:, session:)
        @id = id
        @type = type
        @description = description
        @currency = currency
        @balance = balance
        @session = session
      end

      def transactions(from:, to:)
        session.fetch_transactions(account: self, from: from, to: to)
      end

      private

        attr_reader :session
    end
  end
end
