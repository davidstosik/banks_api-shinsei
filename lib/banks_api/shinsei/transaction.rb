module BanksApi
  module Shinsei
    class Transaction
      attr_reader :date, :ref_no, :description, :amount

      def initialize(date:, ref_no:, description:, amount:)
        @date = date
        @ref_no = ref_no
        @description = description
        @amount = amount
      end

      def self.from_csv_line(csv_line)
        new(
          date: Date.parse(csv_line[:date]),
          ref_no: csv_line[:ref_no],
          description: csv_line[:description],
          amount: csv_line[:credit].to_i- csv_line[:debit].to_i # can both be non zero?
        )
      end

      def to_s
        "#{date},#{ref_no},#{description},#{amount}"
      end
    end
  end
end
