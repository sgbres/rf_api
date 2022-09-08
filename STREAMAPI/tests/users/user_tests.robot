*** Settings ***
Documentation       Test Suite for the 'users' api endpoints

Resource            ../../src/config/constants.resource
Resource            ../../src/resources/setup.resource
Resource            ../../src/helper/database_helper.resource
Library             REST    ${BASE_URL}
Library             Collections
Library             OperatingSystem
Library             JSONLibrary

Suite Setup         Set Bearer Tokens For Test Suite

Default Tags        api_users

*** Variables ***
${ADMIN_BEARER_TOKEN}       ${EMPTY}
${USER_BEARER_TOKEN}        ${EMPTY}
${USER_ID}                  28
${TEAM_MEMBER_ID}           26
&{PATCH_DICT}               username=sbreslin

*** Test Cases ***
# AS AN ADMIN
TC_01_GET_All_Users
    [Documentation]    get all users and validate response status
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}
    Integer    response status    200
    [Teardown]    Output    response body    also_console=true

TC_02_GET_Single_User
    [Documentation]    get single user by userid and validate first name
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}
    Integer    response status    200
    String    $.fname    Seamus
    [Teardown]    Output    response body    also_console=true

TC_03_GET_Current_Logged_User_Information
    [Documentation]    get admin user details and validate lastname
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/current
    Integer    response status    200
    String    $.lname    Admin Account
    [Teardown]    Output    response body    also_console=true

TC_04_GET_User_Public_Information
    [Documentation]    get all public visible info for user and validate profile
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/public
    Integer    response status    200
    Boolean    $.view_profile    true
    [Teardown]    Output    response body    also_console=true

TC_05_GET_Users_Recommended_Goals
    [Documentation]    get users recommended goals and validate response status
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/goals/recommended
    Integer    response status    200
    [Teardown]    Output    response body    also_console=true
#####################################################################
# AS A TEAM MANAGER

TC_06_GET_Team
    [Documentation]    get users team details and validate response status
    Set Headers    {"Authorization": "Bearer ${USER_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/team
    Integer    response status    200
    [Teardown]    Output    response body    also_console=true

TC_07_GET_Team_Report
    [Documentation]    get users team report and validate response status
    Set Headers    {"Authorization": "Bearer ${USER_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/team-report
    Integer    response status    200
    [Teardown]    Output    response body    also_console=true

TC_08_GET_Team_Progress_Report
    [Documentation]    get users team progress report and validate response status
    Set Headers    {"Authorization": "Bearer ${USER_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/team-progress-report
    Integer    response status    200
    [Teardown]    Output    response body    also_console=true

TC_09_GET_Team_Progress_Report_For_Single_User
    [Documentation]    get users team progress report and validate user data
    Set Headers    {"Authorization": "Bearer ${USER_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/team-progress-report
    Integer    response status    200
    Integer    $.items[0].user_id    ${TEAM_MEMBER_ID}
    String    $.items[0].name    Coronavirus Uk
    ${response}=    Output    response body items    also_console=true
    Validate Response Data For User    ${response}    ${TEAM_MEMBER_ID}    status    in_progress
    [Teardown]    Output    response body    also_console=true

TC_10_GET_Team_Stats
    [Documentation]    get users team stats and validate count > 0
    Set Headers    {"Authorization": "Bearer ${USER_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/team-stats
    Integer    response status    200
    ${members_count}=    Output    $.team_members_count    also_console=true
    Should Not Be Equal As Integers    ${members_count}    0
    [Teardown]    Output    response body    also_console=true

TC_11_GET_Team_Users
    [Documentation]    get users team users and validate user ids
    Set Headers    {"Authorization": "Bearer ${USER_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/${USER_ID}/team-users
    Integer    response status    200
    Integer    $..id    26    29    27    55    30
    [Teardown]    Output    response body    also_console=true

TC_12_PATCH_Update_User
    [Documentation]    patch user details and validate update
    Set Headers    {"Authorization": "Bearer ${ADMIN_BEARER_TOKEN}"}
    Get    ${USERS_ENDPOINT}/55
    Integer    response status    200
    Output    response body    also_console=true
    ${current_username}=    Output    $.username    also_console=true
    ${patch_json}=    Get File    ${EXECDIR}/STREAMAPI/tests/test_data/patch_user_data.json
    ${patch_json}=    Convert String To Json    ${patch_json}
    IF    '${current_username}' == 'seamus.breslin@learningpool.com'
        Patch    ${USERS_ENDPOINT}/55    ${PATCH_DICT}
        String    $.username    ${PATCH_DICT.username}
    ELSE
        Patch    ${USERS_ENDPOINT}/55    ${patch_json}
        String    $.username    ${patch_json['username']}
    END
    [Teardown]    Output    response body    also_console=false

*** Keywords ***
Validate Response Data For User
    [Documentation]    vaidates specified data for a user from the response by looping through json
    [Arguments]    ${this_response}    ${this_user_id}    ${item_key}    ${item_value}
    FOR    ${item}    IN    @{this_response}
        IF    '${item['user_id']}' == '${this_user_id}'
            ${exit}=    Run Keyword And Return Status
            ...    Should Be Equal As Strings    '${item['${item_key}']}'    '${item_value}'
            Log    '${item['${item_key}']}':'${item_value}'
        END
        Exit For Loop If    '${item['user_id']}' != '${this_user_id}'
        Exit For Loop If    ${exit}==False
    END

Create A New User For Test Suite
    [Documentation]    create a new user to be used for test
    Create User Through Database    apiTestUser    apiTestUser@lp.com    apiFname    apiLname
    ...    1    null    Europe/London    en
    ...    ""    ""    Derry    ""
