def json_error_response(error_code = 422)
  expect(last_response.status).to eq(error_code.to_i)
  expect(JSON.parse last_response.body.strip).to have_key('errors')
  expect(JSON.parse(last_response.body.strip)['errors']).not_to be_empty
end

def json_error_response_should_be(messages)
  json = JSON.parse last_response.body.strip
  expect(json['errors']).to eq(messages)
end

