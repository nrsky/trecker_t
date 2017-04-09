@elastic-search
Feature: CreateRecord
  Background:
    Given a driver with id 1

  Scenario: Creating a record with correct data
    When I make "POST" request to "/records.json":
    """
      {
        "company_id":123,
        "driver_id":1,
        "timestamp":"2016-12-12T 12:34:33",
        "latitude":52.234234,
        "longitude":13.23324,
        "accuracy":12.0,
        "speed":123.45
      }
   """
    Then I should get a "201" response


  Scenario: Creating a record with incorrect driver_id
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

    Then I should get a "422" response
    And there should be a JSON error response
    And the JSON errors should be:
      | Couldn't find Driver with 'id'=10|


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
      | Validation failed: Longitude can't be blank|
