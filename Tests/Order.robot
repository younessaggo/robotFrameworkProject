*** Settings ***

Resource    ../Resources/api/order_keywords.robot
Suite Setup    Authenticate And Store Token And Client Name
Test Setup    Create A Order With An Available Book
*** Test Cases ***


Delete Order And Validate
    [Tags]    deleteOrder
    Delete Order

Retrieve All Orders And Validate Orders JSON With Schema
    [Tags]    ValidateOrdersSchema
    ${orders}=    Get All Oders
    Order Schema Validator    ${orders}

Retreive An Order And Validate Order Json with Schema
    [Tags]    ValidateOrderSchema
    ${order}=    Get Order By ID
    log    ${order}
    Validate Order With Schema    ${order}

Update Order And Verify Update
    [Tags]    ValidateUpdate
    ${order_befor_update}=    Get Order By ID
    ${customer_name_before_update}=    get from dictionary    ${order_befor_update}    customerName
    Update An Order By ID
    ${order_after_update}=    Get Order By ID
    ${customer_name_after_update}=    get from dictionary    ${order_after_update}    customerName
    should not be equal    ${order_befor_update}    ${order_after_update}




