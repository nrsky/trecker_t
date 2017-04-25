Feature: CreateCompany

  Scenario: Creating a company with correct data
    When I make "POST" request to "/companies.json":
    """
      {
        "name":"Trecker"
      }
   """
    Then I should get a "201" response


  Scenario: Creating a company with incorrect data
    When I make "POST" request to "/companies.json":
    """
      {}
    """
    Then I should get a "422" response
    And there should be a JSON error response
    And the JSON errors should be:
      | Validation failed: Name can't be blank |
