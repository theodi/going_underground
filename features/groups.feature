@vcr
Feature: Return JSON for grouped signals

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"
    And I have the following grouped signals
    """
passesnger_load:
  - passesnger_load_car_a
  - passesnger_load_car_b
  - passesnger_load_car_c
  - passesnger_load_car_d
    """

  Scenario: Get grouped signals
    When I send a GET request to "groups/passesnger-load/2015-09-23T06:00:00/2015-09-23T10:00:00"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0].name" with the text "Passenger Load Car A (%)"
    And the JSON response should have "$.signals[1].name" with the text "Passenger Load Car B (%)"
    And the JSON response should have "$.signals[2].name" with the text "Passenger Load Car C (%)"
    And the JSON response should have "$.signals[3].name" with the text "Passenger Load Car D (%)"

  Scenario: Non-existent group 404s cleanly
    When I send a GET request to "groups/non-existent-group/2015-09-23T06:00:00/2015-09-23T10:00:00"
    Then the response status should be "404"
    And the JSON response should have "$.status" with the text "Group not found"

  Scenario: Return an empty array when a signal in a group has no data
    Given the signal 'passesnger_load_car_c' returns no data
    And I send a GET request to "groups/passesnger-load/2015-09-23T06:00:00/2015-09-23T10:00:00"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0].results[*]" with a length of 4
    And the JSON response should have "$.signals[2].results[*]" with a length of 0
