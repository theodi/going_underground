Feature: Authentication

  Background:
    Given I have the following signals
    """
"signal_1": "1"
"signal_2": "2"
"signal_3": "3"
"signal_4": "4"
    """

  Scenario: Require authorisation to read
    Given I send and accept JSON
    When I send a GET request to "signals.json"
    And I do not authenticate
    Then the response status should be "401"

  Scenario: Require authorisation to read
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"
    When I send a GET request to "signals.json"
    Then the response status should be "200"

  Scenario: Require authorisation for crowding data
    Given I send and accept HTML
    When I send a GET request to "stations"
    And I do not authenticate
    Then the response status should be "401"
