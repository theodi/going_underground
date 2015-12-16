Feature: Sir Handel

  Scenario: GET root with HTML content type
    Given I send and accept HTML
    And I authenticate as the user "thomas" with the password "tank_engine"
    When I send a GET request to "/"
    Then the response status should be "200"

  Scenario: GET root with JSON content type
    Given I send and accept JSON
    And I authenticate as the user "thomas" with the password "tank_engine"
    When I send a GET request to "/"
    Then the response status should be "200"
