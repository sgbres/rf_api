*** Settings ***
Documentation       Test Suite for the 'lx' api endpoints

Resource            ../../src/config/constants.resource
Resource            ../../src/resources/setup.resource
Resource            ../../src/helper/database_helper.resource
Library             REST    ${BASE_URL}
Library             Collections
Library             OperatingSystem
Library             JSONLibrary

Suite Setup         Set User Bearer Token For Test Suite    ${ORG_ADMIN_USERNAME}    ${GLOBAL_PASSWORD}    ${ORG_ID}

Default Tags        completelx

*** Variables ***
${USER_BEARER_TOKEN}    ${EMPTY}
${USER_GOAL_ID}         14

*** Test Cases ***
# AS AN ADMIN
TC_01_GET_All_Users_Discover_Content
    [Documentation]    get all users and validate response status
    Set Headers    {"Authorization": "Bearer ${USER_BEARER_TOKEN}"}
    # Get    /lxp/api/v1/user-learning-activities/55/discover
    Get    /lxp/api/v1/user-goals/${USER_GOAL_ID}/learning-activities
    Integer    response status    200
    [Teardown]    Output    response body    also_console=true
