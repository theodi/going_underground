Feature: Cromulent dates

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  @vcr
  Scenario: Get dates
    When I send a GET request to "cromulent-dates"
    Then the response status should be "200"
    And the JSON response should have "$.start" with the text "2015-08-28T02:50:00+00:00"
    And the JSON response should have "$.end" with the text "2015-09-28T23:30:00+00:00"
