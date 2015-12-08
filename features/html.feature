@vcr @blocktrain
Feature: Get HTML

  Background:
    Given I send and accept HTML
    And I authenticate as the user "thomas" with the password "tank_engine"

  Scenario: Get a chart
    When I send a GET request to "signals/train-speed/2015-09-23T06:00:00/2015-09-23T10:00:00"
    Then the response status should be "200"
    And the XML response should have "//title" with the text "Train Speed"
    And the XML response should have "//div[@id = 'chart']"
