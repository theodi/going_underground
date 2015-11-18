Feature: REST it up

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  @vcr
  Scenario: Get a REST-ish URL
    When I send a GET request to "signals/train_speed"
    Then the response status should be "200"
    And the JSON response should have "$.results[0].timestamp" with the text "2015-09-01T00:00:00+00:00"
