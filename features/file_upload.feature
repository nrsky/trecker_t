Feature: UploadFile
  Background:
    Given a driver with id 123

  Scenario: Parsing data from a file
    When I make a "GET" request to "/upload_file?file_path=records_for_development_test.json&file_type=records"
    Then I should get a "200" response

  Scenario: Parsing data from a file
    When I make a "GET" request to "/upload_file?file_path=fields.json&file_type=fields"
    Then I should get a "200" response



