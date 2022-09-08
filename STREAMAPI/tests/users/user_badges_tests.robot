*** Settings ***
Documentation       Test Suite for the 'users badges' api endpoints

Resource            ../../src/config/constants.resource
Resource            ../../src/resources/setup.resource
Library             REST    ${BASE_URL}
Library             Collections
Library             JSONLibrary

Suite Setup         Set Bearer Tokens For Test Suite

Default Tags        api_usersbadges

*** Variables ***
${ADMIN_BEARER_TOKEN}       ${EMPTY}
${USER_BEARER_TOKEN}        ${EMPTY}
${USER_ID}                  55
${BADGE_ID}                 4

*** Test Cases ***
# AS AN ADMIN
TC_01_GET_User_Badges
    [Documentation]    get all badges for specified users and validate response status
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/badges
    Integer    response status    200
    [Teardown]    Output    response body    also_console=false

TC_02_GET_User_Badge
    [Documentation]    get specified badges for a user and validate response status
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/badges/${BADGE_ID}
    Integer    response status    200
    String    $.name    "Coronavirus"
    ${completed}=    Output    $..['requirements'][0].['completion_model'].['completed_message']
    Should Contain    ${completed}    Congratulations, you have finished
    [Teardown]    Output    response body    also_console=false
