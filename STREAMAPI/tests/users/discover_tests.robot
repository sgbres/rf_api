*** Settings ***
Documentation       Test Suite for the 'discover page' api endpoints

Resource            ../../src/config/constants.resource
Resource            ../../src/resources/setup.resource
Resource            ../../src/helper/database_helper.resource
Library             REST    ${BASE_URL}
Library             Collections
Library             OperatingSystem
Library             JSONLibrary

Suite Setup         Set Bearer Tokens For Test Suite

Default Tags        discover

*** Variables ***
${ADMIN_BEARER_TOKEN}       ${EMPTY}
${USER_BEARER_TOKEN}        ${EMPTY}
${USER_ID}                  28
${TEAM_MEMBER_ID}           26
&{PATCH_DICT}               username=sbreslin

*** Test Cases ***
# AS AN ADMIN
TC_01_GET_All_Users_Discover_Content
    [Documentation]    get all users and validate response status
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    /lxp/api/v1/user-learning-activities/55/discover
    Integer    response status    200
    [Teardown]    Output    response body    also_console=true
