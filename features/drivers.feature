Feature: CreateDriver

  Scenario: Creating a driver with correct data
    When I make "POST" request to "/drivers.json":
    """
      {
        "name":"NameSurname"
      }
   """
    Then I should get a "201" response


  Scenario: Creating a driver with incorrect polygon
    When I make "POST" request to "/drivers.json":
    """
      {}
    """
    Then I should get a "422" response
    And there should be a JSON error response
    And the JSON errors should be:
      | param is missing or the value is empty: driver|
