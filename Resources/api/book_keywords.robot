*** Settings ***
Library    Collections
Resource    ../common/variables.robot
Resource    ../common/common.robot

*** Keywords ***
Book Schema Validator
    [Arguments]    ${books}
    FOR    ${book}    IN    @{books}
        Validate Book With Schema    ${book}
    END

Validte The Unicity Of ID
    [Arguments]    ${books}
    ${ids}=    create list
    FOR    ${book}    IN    @{books}
        append to list    ${ids}    ${book['id']}
    END
    RETURN    ${ids}

Get All Books
    common.Create Api Session
    ${resp}=    GET On Session    apisession    ${ENDPOINT_BOOKS}     expected_status=200
    ${books}=    Set Variable    ${resp.json()}
    RETURN    ${books}


Validate Book With Schema
    [Arguments]    ${book}
    Validate Response With Schema    ${book}    ${BOOK_SCHEMA}


Get Book By ID
    [Arguments]    ${id}
    Create Api Session
    ${endpoint_single_book}=    set variable    ${ENDPOINT_BOOKS}${id}
    ${resp}=    GET On Session    apisession    ${endpoint_single_book}    expected_status=200
    ${book}=    set variable    ${resp.json()}
    RETURN    ${book}

Gets Rrandomly Selected ID
    ${books}=    Get All Books
    ${book_count}=    get length    ${books}
    ${random_index}=    evaluate    random.randint(0,${book_count}-1)    random
    ${random_book}=    get from list    ${books}    ${random_index}
    ${random_book_id}=    get from dictionary    ${random_book}    id
    Log    Randomly selected book ID: ${random_book_id} (index: ${random_index})
    RETURN    ${random_book_id}

Get Randomly Availabale Book
    [Documentation]    Returns a randomly selected book that is available
    ${books}=    Get All Books
    ${available_books}=    create list

    FOR    ${book}    IN    @{books}
        ${is_available}=    get from dictionary    ${book}    available
        IF     ${is_available} == ${TRUE}
            append to list    ${available_books}    ${book}
        END
    END
    ${available_count}=    get length    ${available_books}
    ${random_index}=    evaluate    random.randint(0, ${available_count}-1)    random
    ${random_book}=    Get From List    ${available_books}    ${random_index}
    RETURN    ${random_book}

