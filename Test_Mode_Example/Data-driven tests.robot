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
...    Scenario 2:
...    

Suite Setup
Suite Teardown

Test Setup
Test Teardown
Test Template     Creating user with invalid password should fail

*** Test Cases ***
Invalid password
    [Template]    Creating user with invalid password should fail
    abCD5            ${PWD INVALID LENGTH}
    abCD567890123    ${PWD INVALID LENGTH}
    123DEFG          ${PWD INVALID CONTENT}
    abcd56789        ${PWD INVALID CONTENT}
    AbCdEfGh         ${PWD INVALID CONTENT}
    abCD56+          ${PWD INVALID CONTENT}