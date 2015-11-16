Feature: Default data

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  @vcr
  Scenario: Get default data
    When I send a GET request to "signal"
    Then the response status should be "200"
    And the JSON response should have "$.min" with the text "0.0"
    And the JSON response should have "$.max" with the text "5858.588810837933"
    And the JSON response should have "$.results[6].timestamp" with the text "2015-09-01T06:00:00+00:00"
    And the JSON response should have "$.results[6].value" with the text "4502.75234850831"
