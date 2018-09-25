module BanksApi
  module Shinsei
    class Transaction < Transaction
      attr_reader :ref_no

      def initialize(ref_no:, **other)
        super(other)
        @ref_no = ref_no
      end

      def self.from_csv_line(csv_line, currency:)
        new(
          date: Date.parse(csv_line[:date]),
          ref_no: csv_line[:ref_no],
          description: csv_line[:description],
          amount: csv_line[:credit].to_i - csv_line[:debit].to_i, # can both be non zero?
          currency: currency
        )
      end
    end
  end
end
