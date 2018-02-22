*** Settings ***
Documentation   BDD Wikipedia Explain
...        Story: Returns go to stock
...   As a store owner
...   In order to keep track of stock
...   I want to add items back to stock when they`re returned
...       
...   Scenario 1: Refunded items should be returned to stock
...   Given that a customer previously bought a black sweater from me 
...   And I have three black sweaters in stock 
...   When he return the black sweaters for a refund
...   Then I should have four black sweaters in stock.
...    

Suite Setup    Check Device Online
Suite Teardown    Close Browser

Test Setup     Set Env
Test Teardown     Clean Env
Test Template     Creating user with invalid password should fail

*** Test Cases ***
User can change password
    Given a user has a valid account
    When she changes her password
    Then she can login with the new password
    And she cannot use the old password anymore 
    
Invalid password
    [Template]    Creating user with invalid password should fail
    bacdf         ${PWD INVALID LENGTH}
    3243243       ${PWD INVALID LENGTH}
    oghgfd*(      ${PWD INVALID LENGTH}

        