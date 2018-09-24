module BanksApi
  module Shinsei
    class JsParser
      def self.data_for(html_body)
        new(html_body).data
      end

      def initialize(html_body)
        @html_body = html_body
      end

      def data
        @_data ||= setup_code.
          to_enum(:scan, var_assign_regex).
          inject({}) do |variables|

            name, index, value = Regexp.last_match.captures

            value = parse_value(value)

            if index
              variables[name] ||= []
              variables[name][index.to_i] = value
            else
              variables[name] = value
            end

            variables
          end
      end

      private

        attr_reader :html_body

        def setup_code
          @_setup_code ||= html_body.lines.first.
            match(snippet_regex).
            to_a.fetch(0, "")
        end

        def snippet_regex
          /(?<=<script language="JavaScript">).*(?=<\/script>)/
        end

        def var_assign_regex
          /(\w+)(?:\[(\d+)\])?=(.*?)(?=;)/
        end

        def parse_value(value)
          if value == "new Array()"
            []
          else
            match_numeric(match_string(value))
          end
        end

        def match_string(value)
          value.match(/^('|"|)(.*)\1$/)[2]
        end

        def match_numeric(value)
          match = value.match /^\d{1,3}(,\d{3})*(\.\d*)?$/
          return value unless match
          if match[2]
            value.tr(",", "").to_f
          else
            value.tr(",", "").to_i
          end
        end
    end
  end
end
