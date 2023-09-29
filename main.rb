require 'restclient'
require 'csv'
require 'json'
require 'dotenv'

Dotenv.load

data = {
  financial_statement:
  {
   reference: "5027",
   financial_account_id: ENV['ACCOUNT_ID']
  }
}

lines = {}

CSV.foreach(File.open('input.csv'), headers: true).with_index do |line, i|
  lines.merge!({ i.to_s => { date: line['Datum'],
                             message: line['Omschrijving'].split.join(' '),
                             amount: line['Bedrag'].gsub('+', '') }
              })
end

data[:financial_statement][:financial_mutations_attributes] = lines

begin
  resp = RestClient.post(
    "https://moneybird.com/api/v2/#{ENV['ADMINISTRATION_ID']}/financial_statements.json", data.to_json,
    { 'authorization' => "Bearer #{ENV['TOKEN']}",
      'Content-Type' => 'application/json' })

  puts resp.body
rescue Exception => e
  puts e.response.body
end


