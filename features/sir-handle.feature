Feature: Content Types

  Scenario: GET root with HTML content type
    Given I send and accept HTML
    When I send a GET request to "/"
    Then the response status should be "200"

  Scenario: GET root with JSON content type
    Given I send and accept JSON
    When I send a GET request to "/"
    Then the response status should be "200"
