Feature: Default data

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  @vcr
  Scenario: Get default data
    When I send a GET request to "signal"
    Then the response status should be "200"
    And the JSON response should have "$.results[6].timestamp" with the text "2015-09-01T06:00:00+00:00"
    And the JSON response should have "$.results[6].value" with the text "4502.75234850831"

  @vcr
  Scenario: Specify a date
    When I send a GET request to "signal?from='2015-09-23 00:00:00Z'&to='2015-09-24 00:00:00Z'"
    Then the response status should be "200"
    And the JSON response should have "$.results[0].timestamp" with the text "2015-09-23T04:00:00+00:00"
