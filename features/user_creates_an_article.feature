Feature: User creates an article

  @circumvent-resque @monitor-announcements
  Scenario: A user creates an article
    When I navigate to the article form
    And I create the following article:
      | title | This is great                   |
      | body  | The place is already decorated. |
    Then the article titled "This is great" is announced

  @javascript @announce @inline-resque @monitor-announcements
  Scenario: A user creates an article
    When I navigate to the article form
    And I create the following article:
      | title | This is great                   |
      | body  | The place is already decorated. |
    Then I see that I can jump to an article
