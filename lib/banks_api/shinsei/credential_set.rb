module BanksApi
  module Shinsei
    class CredentialSet
      attr_reader :account, :password, :pin

      def initialize(account:, password:, pin:, code_card:)
        @account = account
        @password = password
        @pin = pin
        @code_card = code_card.split(",")
      end

      def get_grid_value(coordinates)
        x = coordinates[0].tr("A-J", "0-9").to_i
        y = coordinates[1].to_i

        code_card[y][x]
      end

      private

        attr_reader :code_card
    end
  end
end
