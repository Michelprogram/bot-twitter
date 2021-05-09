require_relative 'Twitter_Bot'

$choliere = Twitter_Bot.new

def main
  puts "time #{Twitter_Bot.next_15_hours}"
  sleep (Twitter_Bot.next_15_hours)
  $choliere.Post_image
  main
end

main
