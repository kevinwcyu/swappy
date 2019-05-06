#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

config = JSON.parse(File.read('./config.json'))
from = config['from']
to = config['to']

output = {
    :items => []
}

# TODO validate arguments
amount = Float(ARGV[0]) rescue ARGV[0]

query = {
    :base => from,
    :symbols => to.join(',')
}
uri = URI("#{config['api']}?#{URI.encode_www_form(query)}")
response = JSON.parse(Net::HTTP.get(uri))
response['rates'].each do |currency, rate|
  exchanged_currency_amount = (amount * rate).round(2)
  output[:items].push(
      {
          :title => "#{exchanged_currency_amount} #{currency}",
          :subtitle => "1 #{config['from']} = #{rate} #{currency}",
          :arg => exchanged_currency_amount,
          :icon => {
            :path => "./icons/#{currency}.png"
          }
      }
  )
end

print(output.to_json)
