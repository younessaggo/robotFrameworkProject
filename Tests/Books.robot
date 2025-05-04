*** Settings ***
Resource    ../Resources/api/book_keywords.robot


*** Test Cases ***
Retrieve All Books And Validate Books JSON With Schema
    [Tags]    ValidateBooksSchema
    ${books}=    Get All Books
    Book Schema Validator    ${books}


Retrieve All Books And Validte The Unicity Of ID
    ${books}=    Get All Books
    ${ids}=    Validte The Unicity Of ID    ${books}
    ${orginal_lenght}=    get length    ${ids}
    ${unique_ids}=    remove duplicates  ${ids}
    ${unique_lenght}=    get length    ${unique_ids}
    should be equal     ${unique_lenght}    ${orginal_lenght}

Retrieve Single Book And Validate Book Json With Schema
    [Tags]    ValidateBookSchema
    ${id}=    Gets Rrandomly Selected ID
    ${book}=    Get Book By ID    ${id}
#    ${book_available}=    Get Randomly Availabale Book
    log    ${book}
    Validate Book With Schema   ${book}



*** Keywords ***




