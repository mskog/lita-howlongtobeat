require "lita"
require 'nokogiri'

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/howlongtobeat"

Lita::Handlers::Howlongtobeat.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
