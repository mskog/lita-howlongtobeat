module Lita
  module Handlers
    class Howlongtobeat < Handler

        route(/^(?:hltp|hltb|howlongtobeat)\s+(.*)/i, :howlongtobeat, command: true, help: { t("help.howlongtobeat_key") => t("help.howlongtobeat_value")})

        def howlongtobeat(response)
          HowlongtobeatSearch.new(response.matches[0][0], http).print_result(response)
        end

        class HowlongtobeatSearch
          SEARCH_URL = "https://howlongtobeat.com/search_main.php?page=1"
          SITE_URL = "https://howlongtobeat.com"

          def initialize(term, client = Faraday)
            @term = term
            @client = client
          end

          def print_result(response)
            response.reply("No results found for #{@term}") && return unless title
            response.reply("No data found for how long it will take to complete the main story of '#{title_content}'") && return unless story
            response.reply("It will take about #{story}to beat the main story of '#{title_content}'")
            response.reply("Source: #{SITE_URL}/#{title_href}")
          end

          def story
            text = doc.css(".search_list_tidbit.center")[0].text
            text == '--' ? nil : text
          end

          def title
            doc.css('a')[0]
          end

          def title_href
            title ? title.attr('href') : nil
          end

          def title_content
            title ? title.attr('title') : nil
          end

          def doc
            @data ||= begin
              search = @client.post(SEARCH_URL, queryString: @term, t: 'games', sorthead: 'popular', sortd: 'Normal Order', detail: '0')
              Nokogiri::HTML(search.body)
            end
          end
        end

        Lita.register_handler(self)
    end
  end
end
