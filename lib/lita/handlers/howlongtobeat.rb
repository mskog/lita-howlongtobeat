module Lita
  module Handlers
    class Howlongtobeat < Handler
        SITE_URL = "http://howlongtobeat.com"
        SEARCH_URL = "http://howlongtobeat.com/search_main.php?page=1"

        route(/^(?:hltp|howlongtobeat)\s+(.*)/i, :howlongtobeat, command: true)

        def howlongtobeat(response)
          term = response.matches[0][0]
          search = http.post(SEARCH_URL, queryString: term, t: 'games', sorthead: 'popular', sortd: 'Normal Order', detail: '0')
          document = Nokogiri::HTML(search.body)
          title = document.css('a')[0]
          response.reply("No results found for #{term}") && return unless title
          story = document.css(".search_list_tidbit.center.time_100")[0].text
          response.reply("It will take about #{story}to beat the main story of #{title.attr('title')}")
          response.reply("#{SITE_URL}/#{title.attr('href')}")
        end

        Lita.register_handler(self)
    end
  end
end
