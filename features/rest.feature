@vcr @blocktrain
Feature: REST it up

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  Scenario: Standard URL should redirect
    When I send a GET request to "signals/train-speed"
    Then the response status should be "302"

  Scenario: Support DateTime durations in URLs
    When I send a GET request to "signals/train-speed/2015-12-11T06:00:00/2015-12-11T10:00:00?interval=1h"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0].name" with the text "Train Speed"
    And the JSON response should have "$.signals[0]results[0].timestamp" with the text "2015-12-11T06:00:00+00:00"
    And the JSON response should have "$.signals[0]results[3].timestamp" with the text "2015-12-11T09:00:00+00:00"

  Scenario: Get raw data
    When I send a GET request to "signals/train-speed/2015-12-11T09:00:00/2015-12-11T11:00:00"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0].name" with the text "Train Speed"
    And the JSON response should have "$.signals[0]results[0].timestamp" with the text "2015-12-11T09:01:00+00:00"
    And the JSON response should have "$.signals[0]results[1].timestamp" with the text "2015-12-11T09:02:01+00:00"

  Scenario: Allow intervals to be set as query strings
    When I send a GET request to "signals/train-speed/2015-12-11T06:00:00/2015-12-11T10:00:00?interval=5s"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0]results[0].timestamp" with the text "2015-12-11T06:00:00+00:00"
    And the JSON response should have "$.signals[0]results[1].timestamp" with the text "2015-12-11T06:10:55+00:00"

  Scenario: Allow two signals to be set
    When I send a GET request to "signals/train-speed,passesnger-load-car-b/2015-12-11T06:00:00/2015-12-11T10:00:00?interval=5s"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0].name" with the text "Train Speed"
    And the JSON response should have "$.signals[1].name" with the text "Passenger Load Car B (%)"
    And the JSON response should have "$.signals[1]results[0].timestamp" with the text "2015-12-11T06:00:00+00:00"
    And the JSON response should have "$.signals[1]results[1].timestamp" with the text "2015-12-11T06:10:55+00:00"

  Scenario: Don't let to date be less than from date
    When I send a GET request to "signals/train-speed/2015-12-11T10:00:00/2015-12-11T06:00:00"
    Then the response status should be "400"
    And the JSON response should have "$.status" with the text "'from' date must be before 'to' date."

  Scenario: Handle invalid datetimes
    When I send a GET request to "signals/train-speed/madeupdate/anothermadeupdate"
    Then the response status should be "400"
    And the JSON response should have "$.status" with the text "'madeupdate' is not a valid ISO8601 date/time. 'anothermadeupdate' is not a valid ISO8601 date/time."

  Scenario: Don't let more than two signals to be set
    When I send a GET request to "signals/train-speed,passesnger-load-car-b,passesnger-load-car-c/2015-12-11T06:00:00/2015-12-11T10:00:00?interval=5s"
    Then the response status should be "400"
    And the JSON response should have "$.status" with the text "Please set a maximum of two signals"
