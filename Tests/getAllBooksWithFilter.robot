*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem
Library    Collections
Resource    ../Resources/common/common.robot
Resource    ../Resources/api/book_keywords.robot
Library    DataDriver    ../Data/BooksFilter.csv

*** Test Cases ***
Filter Books With Parameter Type - ${attribut}=${value}
    [Template]    Filter Books By Parameter


*** Keywords ***

Filter Books By Parameter
    [Arguments]    ${attribut}    ${value}
    Create Api Session
    ${params}=    create dictionary    ${attribut}=${value}
    ${resp}=  Get On Session    apisession    ${ENDPOINT_BOOKS}     params=${params}
    Status Should Be    200    ${resp}
    ${books}=    Set Variable    ${resp.json()}

    FOR    ${book}    IN    @{books}
        SHOULD BE EQUAL AS STRINGS    ${book}[${attribut}]    ${value}
        ...    msg=book type ${book}[${attribut}] doesn't match expected value ${value}
    END