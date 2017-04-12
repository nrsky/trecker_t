When(/^I make "(.*?)" request to "(.*?)":$/) do |method, url, raw_data|
  params = JSON.parse(raw_data)
  self.send(method.downcase, eval('"' + url + '"'), params.to_json, {'CONTENT_TYPE' => 'application/json'})
end

When(/^I make "(.*?)" request to "(.*?)" with file "(.*?)"$/) do |method, url, file_name|
  file = uploaded_fixture_file(file_name)
  send_request method, url, {file: file}
end

When(/^I make a "(.*?)" request to "([^"]*?)"$/) do |method, url|
  send_request method, url
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

Then(/^there should be a JSON response$:/) do |raw_data|
  expect(JSON.parse last_response.body.strip).to have_key('errors')
end

def send_request(request_type, path, params={})
  request path, method: request_type.downcase.to_sym, params: params
end

def uploaded_fixture_file(fixture_name, content_type = "text/plain")
  Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/", fixture_name), content_type)
end

