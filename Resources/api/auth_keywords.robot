*** Settings ***
Library    RequestsLibrary
Library    String
Resource    ../common/variables.robot
Library    Collections
Resource    ../common/common.robot
Library    lib/TokenManager.py
*** Keywords ***
Authenticate And Store Token For New Client
    [Documentation]    Registers a new client, retrieves its token, stores it into a file, and returns the client name.
    Create Api Session
    ${credentials}=    Generate Random Credentials
    ${response}=    Send Auth Request    ${credentials}
    ${client_name}=    Get Client Name    ${credentials}
    ${token}=    Extract Access Token    ${response}
    store token into a file    ${client_name}    ${token}
    RETURN    ${client_name}

Get Client Name
    [Arguments]    ${data}
    ${name}=    get from dictionary    ${data}    clientName
    RETURN    ${name}

Generate Random Credentials
    [Documentation]    Generates random client credentials
    ${random_string}=    Generate Random String    8    [LOWER]
    ${timestamp}=    Get Time    epoch
    ${random_email}=    Set Variable    user_${random_string}_${timestamp}${EMAIL_SUFFIX}
    ${random_name}=    set variable    ${random_string}${timestamp}

    ${credentials}=    Create Dictionary
    ...    clientName=${random_name}
    ...    clientEmail=${random_email}

    RETURN    ${credentials}


Send Auth Request
    [Documentation]    Sends authentication request with provided credentials
    [Arguments]    ${credentials}

    ${headers}=    Create Dictionary    Content-Type=application/json

    ${response}=    POST On Session
    ...    apisession
    ...    ${ENDPOINT_API_CLIENTS}
    ...    json=${credentials}
    ...    headers=${headers}
    ...    expected_status=201

    RETURN    ${response}

Extract Access Token
    [Documentation]    Extracts and validates access token from response
    [Arguments]    ${response}

    Dictionary Should Contain Key    ${response.json()}    accessToken
    ...    msg=Response does not contain access token

    ${token}=    Set Variable    ${response.json()}[accessToken]
    Log    Authentication token generated successfully    level=INFO

    RETURN    ${token}

Store Token Into A file
    [Arguments]    ${token_key}    ${token_value}
    store token    ${token_key}    ${token_value}

Get Token From File
    [Arguments]    ${token_key}
    ${token}=    get token    ${token_key}
    RETURN    ${token}

#Generate A Random Sring
#    ${random}=    evaluate    random.sample([unicode(x) for x in range(1,11)],4)    random
#    ${randomEmail}=    ${random}${emailSuffix}
#    RETURN    ${randomEmail}
