require "csv"
require "faraday"
require "kconv"
require "banks_api/shinsei/js_parser"
require "banks_api/shinsei/account"
require "banks_api/shinsei/transaction"
require "banks_api/shinsei/faraday_middleware"

module BanksApi
  module Shinsei
    class Session
      def initialize(credentials)
        @credentials = CredentialSet.new(credentials)
      end

      def fetch_accounts
        login
        data = connection.post(nil, accounts_data).body

        data["fldAccountID"].map.with_index do |account_id, index|
          Account.new(
            id: account_id,
            type: data["fldAccountType"][index],
            description: data["fldAccountDesc"][index],
            currency: data["fldCurrCcy"][index],
            balance: data["fldCurrBalance"][index],
            base_balance: data["fldBaseBalance"][index],
            session: self
          )
        end

        # logout
      end

      def fetch_transactions(account:, from:, to:)
        login
        fetch_accounts
        transactions_data(account: account, from: from, to: to, step: 1)
        post_data = transactions_data(account: account, from: from, to: to, step: 2)
        response = connection.post(nil, post_data)
        csv = response.body.lines[9..-1].join
        headers = [:date, :ref_no, :description, :debit, :credit, :balance]
        CSV.parse(csv, col_sep: "\t", headers: headers).map do |csv_line|
          Transaction.from_csv_line(csv_line)
        end
      end

      private

        attr_reader :credentials, :session_id

        URL = "https://pdirect04.shinseibank.com/FLEXCUBEAt/LiveConnect.dll".freeze
        private_constant :URL

        def login
          data = connection.post(nil, login_phase1_data).body
          @session_id = data["fldSessionID"]
          response = connection.post(nil, login_phase2_data(data))
          #data = JsParser.data_for(response.body)
        end

        def logout
        end

        def connection
          @_connection ||= initialize_connection
        end

        def initialize_connection
          Faraday.new(url: URL) do |faraday|
            faraday.request(:url_encoded)
            faraday.use(FaradayMiddleware)
            faraday.adapter(Faraday.default_adapter)
          end
        end

        def login_phase1_data
          {
            "MfcISAPICommand" => "EntryFunc",
            "fldAppID" => "RT",
            "fldTxnID" => "LGN",
            "fldScrSeqNo" => "01",
            "fldRequestorID" => "41",
            "fldDeviceID" => "01",
            "fldUserID" =>  credentials.account,
            "fldUserNumId" =>  credentials.pin,
            "fldUserPass" =>  credentials.password,
            "fldLangID" => "ENG", # or JPN
            "fldRegAuthFlag" => "A"
          }
        end

        def login_phase2_data(data)
          {
            "MfcISAPICommand" => "EntryFunc",
            "fldAppID" => "RT",
            "fldTxnID" => "LGN",
            "fldScrSeqNo" => "41",
            "fldRequestorID" => "55",
            "fldSessionID" => session_id,
            "fldDeviceID" => "01",
            "fldGridChallange1" => credentials.get_grid_value(data["fldGridChallange1"]),
            "fldGridChallange2" => credentials.get_grid_value(data["fldGridChallange2"]),
            "fldGridChallange3" => credentials.get_grid_value(data["fldGridChallange3"]),
            "fldUserID" => "",
            "fldUserNumId" => "",
            "fldNumSeq" => "1",
            "fldLangID" => "ENG",
            "fldRegAuthFlag" => data["fldRegAuthFlag"]
          }
        end

        def accounts_data
          {
            "MfcISAPICommand" => "EntryFunc",
            "fldAppID" => "RT",
            "fldTxnID" => "ACS",
            "fldScrSeqNo" => "00",
            "fldRequestorID" => "23",
            "fldSessionID" => session_id,
            "fldAcctID" => "",
            "fldAcctType" => "CHECKING",
            "fldIncludeBal" => "Y",
            "fldPeriod" => "",
            "fldCurDef" => "JPY"
          }
        end

        def transactions_data(account:, from:, to:, step:)
          {
            "MfcISAPICommand" => "EntryFunc",
            "fldScrSeqNo" => "01",
            "fldAppID" => "RT",
            'fldSessionID'=> session_id,
            "fldTxnID" => %w(ACA DAA)[step-1],
            "fldRequestorID" => "9",
            "fldAcctID" => account.id,
            "fldAcctType" => account.type,
            "fldIncludeBal" => "N",
            "fldStartDate" => from.strftime("%Y%m%d"),
            "fldEndDate" => to.strftime("%Y%m%d"),
            "fldStartNum" => "0",
            "fldEndNum" => "0",
            "fldCurDef" => "JPY",
            "fldPeriod" => (from ? "2" : "1")
          }
        end
    end
  end
end
