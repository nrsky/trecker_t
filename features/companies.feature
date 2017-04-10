Feature: CreateCompany

  Scenario: Creating a company with correct data
    When I make "POST" request to "/companies.json":
    """
      {
        "name":"Trecker"
      }
   """
    Then I should get a "201" response


  Scenario: Creating a company with incorrect polygon
    When I make "POST" request to "/companies.json":
    """
      {}
    """
    Then I should get a "422" response
    And there should be a JSON error response
    And the JSON errors should be:
      | param is missing or the value is empty: company|
