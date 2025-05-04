*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem
Library    Collections
Resource    variables.robot
Library    JSONSchemaLibrary    ${CURDIR}${/}..${/}schemas
*** Keywords ***


Create Api Session
    [Documentation]    Creates a session for authentication requests
    Create Session    apisession    ${BASE_URL}    verify=True

Validate Response With Schema
    [Arguments]    ${resp}    ${SCHEMA}
    VALIDATE JSON    ${SCHEMA}    ${resp}
