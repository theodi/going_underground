Feature: Default data

  Background:
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"

  Scenario: Get default data
    Given I have the following signals
    """
"signal_1": "1"
"signal_2": "2"
"signal_3": "3"
"signal_4": "4"
    """
    When I send a GET request to "signals"
    Then the response status should be "200"
    And the JSON response should have "$.signals[0].name" with the text "signal_1"
    And the JSON response should have "$.signals[0].url" with the text "http://example.org/signals/signal-1.json"
