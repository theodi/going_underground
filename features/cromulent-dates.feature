Feature: Cromulent dates

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  Scenario: Get dates
    Given I have the following Cromulent Dates
    """
    {"start":"2015-08-28T02:00:00+00:00","end":"2015-09-28T23:00:00+00:00"}
    """
    When I send a GET request to "cromulent-dates"
    Then the response status should be "200"
    And the JSON response should have "$.start" with the text "2015-08-28T02:00:00+00:00"
    And the JSON response should have "$.end" with the text "2015-09-28T23:00:00+00:00"

  @vcr
  Scenario: Dates may be missing
    Given I have no Cromulent Dates
    When I send a GET request to "cromulent-dates"
    Then the response status should be "200"
    And the JSON response should have "$.start" with the text "2015-08-28T02:00:00+00:00"
    And the JSON response should have "$.end" with the text "2015-09-28T23:00:00+00:00"
