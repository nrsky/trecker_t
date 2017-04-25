Feature: CreateField

  Scenario: Creating a field with correct data
    When I make "POST" request to "/fields.json":
    """
      {
        "name":"BonnField",
        "shape":"75.15 29.53,77 29,77.6 29.5,75.15 29.53"
      }
   """
    Then I should get a "201" response


  Scenario: Creating a record with incorrect polygon
    When I make "POST" request to "/fields.json":
    """
      {
        "name":"BonnField",
        "shape":"75.15 29.53,77.6 29.5,75.15 29.53"
      }
    """

    Then I should get a "422" response
    And there should be a JSON error response
    And the JSON errors should be:
      | Validation failed: Shape cannot be empty or the data is not a polygon|


  Scenario: Creating a record without a name
    When I make "POST" request to "/fields.json":
   """
      {
        "shape":"75.15 29.53,77 29,77.6 29.5,75.15 29.53"
      }
   """

    Then I should get a "422" response
    And there should be a JSON error response
    And the JSON errors should be:
      | Validation failed: Name can't be blank|
