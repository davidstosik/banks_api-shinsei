module BanksApi
  class BankNameResolver
    def initialize(bank_name)
      @bank_name = bank_name
    end

    def domain
    end
  end
end

module BanksApi
  module UserAccount
    def initialize(bank:, credentials:)
      @bank = bank
      @credentials = credentials
    end

    def accounts
      @accounts ||= api.fetch_accounts
    end

    private

      attr_reader :bank, :credentials

      def api
        bank_domain::Session
      end

      def bank_domain
        BankNameResolver.new(bank).domain
      end
  end
end

module BanksApi
  module Shinsei
    class UserAccount < UserAccount
      def initialize(bank:, credentials:)
        super
        @session = Session.new(credentials)
      end

      def accounts
      end

      private

        attr_reader :session
    end
  end
end
