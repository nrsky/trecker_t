def json_error_response(error_code = 422)
  expect(last_response.status).to eq(error_code.to_i)
  expect(JSON.parse last_response.body.strip).to have_key('errors')
  expect(JSON.parse(last_response.body.strip)['errors']).not_to be_empty
end

def json_error_response_should_be(messages)
  json = JSON.parse last_response.body.strip
  expect(json['errors']).to eq(messages)
end

Then(/^the response should contain the complex JSON:$/) do |expected_json |
  actual   = JSON.parse(last_response.body)
  expected = JSON.parse(expected_json)

  result, message = deep_contains?(expected, actual)
  expect(result).to be_truthy, message
end

def deep_contains?(expected, actual, path="")
  return true if expected.nil? and actual.nil?
  return [false, "No actual value at #{path}"] if actual.nil?
  return [false, "Destination and source are different types (Expected: Hash, Got: #{actual.class.name}) at #{path}"] if (expected.class.is_a? Hash) && !(actual.class.is_a? Hash)
  return [false, "Destination and source are different types (Expected: Array, Got: #{actual.class.name}) at #{path}"] if (expected.class.is_a? Array) && !(actual.class.is_a? Array)
  if expected.is_a? Hash
    expected.each_pair do |k, v|
      return false, "Actual does not have an expected key #{path}/#{k}" unless actual.has_key? k
      result, message = deep_contains?(v, actual[k], "#{path}/#{k}")
      return result, message unless result
    end
  elsif expected.is_a? Array
    expected.each_with_index do |v, index |
      result, message = deep_contains?(v, actual[index], "#{path}/[#{index}]")
      return result, message unless result
    end
  else
    return false, "Actual value '#{actual}':#{actual.class.name} does not match '#{expected}':#{expected.class.name} at #{path}" unless actual.eql?(expected)
  end
  return true, ""
end

