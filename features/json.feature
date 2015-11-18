Feature: Default data

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  @vcr
  Scenario: Get default data
    When I send a GET request to "signal"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0].name" with the text "actual_motor_power"
    And the JSON response should have "$.signals[0].url" with the text "http://example.org/signals/actual-motor-power.json"
