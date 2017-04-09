When(/^I make "(.*?)" request to "(.*?)":$/) do |method, url, raw_data|
  params = JSON.parse(raw_data)
  self.send(method.downcase, eval('"' + url + '"'), params.to_json, {'CONTENT_TYPE' => 'application/json'})
end

Then(/^I should get a "(.*?)" response$/) do |code|
  expect(last_response.status).to eq(code.to_i)
end

Then(/^there should be a JSON error response$/) do
  json_error_response
end

Then(/^the JSON errors should be:$/) do |table|
  json_error_response_should_be(table.raw.flatten)
end
