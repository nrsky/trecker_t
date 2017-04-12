Feature: UploadFile
  Background:
    Given a driver with id 123

  Scenario: Parsing data from a file
    When I make "POST" request to "/records/upload" with file "records.json"
    Then I should get a "200" response
    And the response should contain the complex JSON:
      """
      {
        "total_count": 3
      }
      """





