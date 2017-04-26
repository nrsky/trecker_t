Feature: CreateRecord
  Background:
    Given a driver with id 1
    Given a field "field" with valid shape
    Given records in elastic search with driver_id "1"

  Scenario: Creating a record with correct data
    When I make "POST" request to "/records.json":
    """
      {
       "company_id":123,
       "driver_id":10,
       "timestamp":"2016-12-12T 12:34:34",
       "latitude":52.234234,
       "longitude":13.23324,
       "accuracy":12.0,
       "speed":123.45
      }
    """

    Then I should get a "201" response
    And the response should contain the complex JSON:
      """
       {
       "company_id":123,
       "driver_id":10,
       "timestamp":"2016-12-12T12:34:34.000+00:00",
       "latitude":52.234234,
       "longitude":13.23324,
       "accuracy":12.0,
       "speed":123.45
       }
      """


  Scenario: Creating a record with incorrect Longitude
    When I make "POST" request to "/records.json":
    """
      {
       "company_id":123,
       "driver_id":1,
       "timestamp":"2016-12-12T 12:34:34",
       "latitude":52.234234,
       "accuracy":12.0
      }
    """

    Then I should get a "422" response
    And there should be a JSON error response
    And the JSON errors should be:
      | [:longitude, "can't be blank"]|

  #TODO time changes dynamically, add step to verify date_from, date_to and time exists for the step
  Scenario: Processed_time_by_activities
    When I make a "GET" request to "/records/processed_time_by_activities?driver_id=1"
    Then I should get a "200" response
    And the response should contain the complex JSON:
      """
       {
        "result":{
        "driving": {"data":[]},
        "cultivating": {"data":[]},
        "repairing": {"data":[]}
        }
       }
      """
