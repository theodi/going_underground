Feature: Default dashboard JSON

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  Scenario: Get default JSON
    When I send a GET request to "dashboards/general-train/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00"
    Then the response status should be "200"
    And the JSON response should have "$.signals"
    And the JSON response should have "$.signals[0].name" with the text "Train Number"
    And the JSON response should have "$.signals[1].url" with the text "http://example.org/signals/crew-number"
