*** Settings ***
Documentation       Setup to generate a JWT for test suites

Resource            ../config/constants.resource
Resource            ../helper/database_helper.resource
Library             REST    ${BASE_URL}
Library             Collections

*** Variables ***
${BEARER_TOKEN}     ${EMPTY}

*** Keywords ***
Generate User JWT
    [Documentation]    Generate JWT for user
    ...    Send specific user authorization json in request
    [Arguments]    ${user_authorization_json}
    Set Ssl Verify    false
    Post    ${AUTHENTICATION_ENDPOINT}    ${user_authorization_json}
    Integer    response status    200
    ${token}=    Output    $.token    also_console=false
    [Return]    ${token}

Set Bearer Tokens For Test Suite
    [Documentation]    sets the the bearer token for the tests cases
    ${admin_jwt}=    Generate User JWT    ${ADMIN_AUTH_JSON}
    ${user_jwt}=    Generate User JWT    ${USER_AUTH_JSON}
    Set Suite Variable    ${ADMIN_BEARER_TOKEN}    ${admin_jwt}
    Set Suite Variable    ${USER_BEARER_TOKEN}    ${user_jwt}

Set User Bearer Token For Test Suite
    [Documentation]    sets the the bearer token for the tests cases
    [Arguments]    ${username}    ${password}    ${org}
    ${this_user_auth_json}=    Set User Json Data For JWT Request    ${username}    ${password}    ${org}
    ${user_jwt}=    Generate User JWT    ${this_user_auth_json}
    Set Suite Variable    ${USER_BEARER_TOKEN}    ${user_jwt}

Set User Json Data For JWT Request
    [Documentation]    set the json data or the jwt request
    [Arguments]    ${username}    ${password}    ${org}
    ${user_auth_json}=    Catenate    {"username": "${username}",
    ...    "password": "${GLOBAL_PASSWORD}",
    ...    "administer_org_id": ${ORG_ID}}

    [Return]    ${user_auth_json}
