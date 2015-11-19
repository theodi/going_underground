@vcr @blocktrain
Feature: REST it up

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  Scenario: Get a REST-ish URL
    When I send a GET request to "signals/train-speed"
    Then the response status should be "200"
    And the JSON response should have "$.results[0].timestamp" with the text "2015-09-01T00:00:00+00:00"

  Scenario: Support DateTime durations in URLs
    When I send a GET request to "signals/train-speed/2015-09-23T06:00:00/2015-09-23T10:00:00"
    Then the response status should be "200"
    And the JSON response should have "$.results[0].timestamp" with the text "2015-09-23T05:00:00+00:00"
    And the JSON response should have "$.results[3].timestamp" with the text "2015-09-23T08:00:00+00:00"

  Scenario: Allow intervals to be set as query strings
    When I send a GET request to "signals/train-speed/2015-09-23T06:00:00/2015-09-23T10:00:00?interval=5s"
    Then the response status should be "200"
    And the JSON response should have "$.results[0].timestamp" with the text "2015-09-23T05:00:00+00:00"
    And the JSON response should have "$.results[1].timestamp" with the text "2015-09-23T05:00:05+00:00"
