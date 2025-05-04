*** Settings ***
Resource    auth_keywords.robot
Resource    book_keywords.robot
Library    Collections
Resource    ../common/variables.robot
Resource    ../common/common.robot
*** Variables ***
${AUTH_TOKEN}     ${EMPTY}
${CLIENT_NAME}     ${EMPTY}
${ORDER_ID}     ${EMPTY}
${ORDER_SCHEMA}    order_schema.json
*** Keywords ***

Create Order
    [Arguments]    ${book_id}    ${customer_name}    ${expected_status}    ${message}
    ${body}=    Create Dictionary    bookId=${book_id}    customerName=${customer_name}
    log    ${AUTH_TOKEN}
    ${header}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}    Content-type=application/json

    ${response}=    Run Keyword If    ${expected_status} == 201
    ...    POST On Session    apisession    ${ENDPOINT_ORDER}    json=${body}    headers=${header}
    ...    ELSE
    ...    POST On Session    apisession    ${ENDPOINT_ORDER}    json=${body}    headers=${header}    expected_status=${expected_status}

    ${responseBody}=    Convert To String    ${response.content}
    log    ${responseBody}
    Should Contain    ${responseBody}    ${message}
    IF    ${expected_status} == 201
        ${parsed}=    Evaluate    json.loads('''${responseBody}''')    json
        ${order_id}=     Get From Dictionary    ${parsed}    orderId
        set suite variable    ${order_id}
        log    ${order_id}
    END
    Should Contain    ${responseBody}    ${message}

Create A Order With An Available Book
    ${header}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}    Content-type=application/json
    ${book}=    Get Randomly Availabale Book
    ${book_id}=    get from dictionary    ${book}    id
    ${body}=    Create Dictionary    bookId=${book_id}    customerName=${CLIENT_NAME}
    ${resp}=    POST On Session    apisession    ${ENDPOINT_ORDER}    json=${body}   headers=${header}
    ${order}=    set variable    ${resp.json()}
    ${id}=    Get From Dictionary    ${order}    orderId
    set global variable    ${ORDER_ID}    ${id}


Get All Oders

    ${header}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}
    ${resp}=    Get On Session    apisession    ${ENDPOINT_ORDER}    headers=${header}    expected_status=200
    ${orders}=    set variable    ${resp.json()}
    LOG    ${orders}
    RETURN    ${orders}


Delete Order
    ${header}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}
    Delete On Session    apisession    ${ENDPOINT_ORDER}${ORDER_ID}    headers=${header}    expected_status=204

Validate Order With Schema
    [Arguments]    ${order}
    Validate Response With Schema    ${order}    ${ORDER_SCHEMA}

Order Schema Validator
    [Arguments]    ${orders}
    FOR    ${order}    IN    @{orders}
        Validate Order With Schema    ${order}
    END

Gets Rrandomly Selected ID
    ${orders}=    Get All Oders
    ${orders_count}=    get length    ${orders}
    ${random_index}=    evaluate    random.randint(0,${orders_count}-1)    random
    ${random_order}=    get from list    ${orders}    ${random_index}
    ${random_order_id}=    get from dictionary    ${random_order}    id
    Log    Randomly selected book ID: ${random_order_id} (index: ${random_index})
    RETURN    ${random_order_id}

Authenticate And Store Token And Client Name
    ${name}=    Authenticate And Store Token For New Client
    ${token}=    get token from file    ${name}
    set global variable    ${AUTH_TOKEN}    ${token}
    set global variable    ${CLIENT_NAME}    ${name}
#    log    ${AUTH_TOKEN}

Get Order By ID
    ${header}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}
    ${resp}=    GET On Session    apisession    ${ENDPOINT_ORDER}${ORDER_ID}    headers=${header}    expected_status=200
    ${order}=    set variable    ${resp.json()}
    RETURN    ${order}

Update An Order By ID
    ${header}=    Create Dictionary    Authorization=Bearer ${AUTH_TOKEN}
    ${customer_name}=    Generate Random String    8    [LOWER]
    ${body}=    create dictionary    customerName=${customer_name}
    ${id}=    set variable    ${ORDER_ID}
    PATCH On Session    apisession    ${ENDPOINT_ORDER}${ORDER_ID}    json=${body}    headers=${header}    expected_status=204


#Order Suite Setup
#    Authenticate And Store Token And Client Name
#    Create A Order With An Available Book



