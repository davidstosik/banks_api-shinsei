module BanksApi
  module Shinsei
    class BankAccount < BankAccount
      attr_reader :type, :base_balance

      def initialize(type:, base_balance:, session:, **other)
        super(other)
        @type = type
        @base_balance = base_balance
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
