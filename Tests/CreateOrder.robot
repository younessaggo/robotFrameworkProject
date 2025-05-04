*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../Resources/api/auth_keywords.robot
Resource    ../Resources/api/order_keywords.robot
Resource    ../Resources/common/common.robot
Suite Setup    Authenticate And Store Token And Client Name
Test Template    Create Order

#Suite Setup    Login With A Valid Crendantials


*** Test Cases ***                                  BOOK ID                     CUSTOMER NAME                EXPECTED STATUS    MESSAGE
Create Order - With An Available Book                 1                         John                           201              true
Create Order - Unavailable Book                       2                         John                           404              This book is not in stock. Try again later



