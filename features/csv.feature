@vcr @blocktrain
Feature: Get some CSVs

  Background:
    Given I request CSV
    And I authenticate as the user "thomas" with the password "tank_engine"

  Scenario: Get CSV data
    When I send a GET request to "/signals/passesnger_load_car_b/2015-09-01T00:00:00+00:00/2015-09-01T01:00:00+00:00?interval=30m"
    Then the response status should be "200"
    And the response should be a CSV
    And the CSV response should have the headers:
    """
    timestamp
    passesnger_load_car_b
    """
    And the CSV response should have the values:
    """
    2015-09-01T00:30:00+00:00
    12.605633802816902
    """

  Scenario: Get CSV data for two signals
    When I send a GET request to "/signals/passesnger_load_car_a,passesnger_load_car_b/2015-09-01T00:00:00+00:00/2015-09-01T01:00:00+00:00?interval=30m"
    Then the response status should be "200"
    And the response should be a CSV
    And the CSV response should have the headers:
    """
    timestamp
    passesnger_load_car_a
    passesnger_load_car_b
    """
    And the CSV response should have the values:
    """
    2015-09-01T00:30:00+00:00
    12.605633802816902
    3.1140350877192984
    """
