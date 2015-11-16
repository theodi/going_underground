Feature: Authentication

  Scenario: Require authorisation to read
    Given I send and accept JSON
    When I send a GET request to "signal"
    And I do not authenticate
    Then the response status should be "401"

  @vcr
  Scenario: Require authorisation to read
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"
    When I send a GET request to "signal"
    Then the response status should be "200"
