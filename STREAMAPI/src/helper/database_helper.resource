*** Settings ***
Library     DatabaseLibrary
Resource    ../config/constants.resource


*** Keywords ***
Connect
    Connect To Database    pymysql    ${DB_NAME}    ${DB_USERNAME}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}

Disconnect
    Disconnect From Database

Create User Through Database
    [Arguments]    ${username}    ${email}    ${first_name}    ${last_name}
    ...    ${org_id}    ${expires_at}    ${timezone}    ${language}
    ...    ${org_ref}    ${summary}    ${location}    ${function}
    ${username} =    Normalize Value    ${username}
    ${email} =    Normalize Value    ${email}
    ${first_name} =    Normalize Value    ${first_name}
    ${last_name} =    Normalize Value    ${last_name}
    ${org_id} =    Normalize Value    ${org_id}
    ${expires_at} =    Normalize Value    ${expires_at}
    ${timezone} =    Normalize Value    ${timezone}
    ${language} =    Normalize Value    ${language}
    ${org_ref} =    Normalize Value    ${org_ref}
    ${summary} =    Normalize Value    ${summary}
    ${location} =    Normalize Value    ${location}
    ${function} =    Normalize Value    ${function}
    Connect
    Execute Sql String
    ...    INSERT INTO `users` (`org_id`, `uuid`, `username`, `sso_id`, `email`, `password`, `fname`, `lname`, `tag_line`, `summary`, `location`, `function`, `websites`, `org_ref`, `admin`, `reply_email`, `digest_email`, `object_comments`, `view_profile`, `view_objects`, `leaderboard_opt_out`, `super_user`, `timezone`, `language`, `expires_at`, `created_at`, `updated_at`, `deleted_at`, `remember_token`, `terms_accepted`, `terms_accepted_at`, `terms_declined_at`, `notifications_last_viewed_at`, `seniority`) VALUE(${org_id}, NULL, ${username}, NULL, ${email}, '$2y$10$en1lCcE2eDq.J4rbXGRLRe2nn/9WhP/7kImCIwlt6.l.0.zxlq9ce', ${first_name}, ${last_name}, '', ${summary}, ${location}, ${function}, '', ${org_ref}, '0', '1', '1', '1', '1', '1', '0', '0', ${timezone}, ${language}, ${expires_at}, now(), now(), NULL, NULL, '0', NULL, NULL, NULL, NULL);
    ${id} =    Get Id Of Last Inserted Item
    Disconnect
    RETURN    ${id}

Search Users Through Database
    [Arguments]    ${field_name}    ${operator}    ${search_value}
    ${search_value} =    Normalize Value    ${search_value}
    Connect
    ${data} =    Query
    ...    SELECT * FROM `users` WHERE `${field_name}` ${operator} ${search_value} ORDER BY `id` ASC LIMIT 50;
    Disconnect
    RETURN    ${data}

Set Organization Role Through Database
    [Arguments]    ${user_id}    ${role_id}    ${org_id}
    ${user_id} =    Normalize Value    ${user_id}
    ${role_id} =    Normalize Value    ${role_id}
    ${modal_id} =    Normalize Value    ${org_id}
    Connect
    Execute Sql String
    ...    INSERT INTO `user_role` (`user_id`, `role_id`, `model_id`, `created_at`, `updated_at`) VALUES (${user_id}, ${role_id}, ${modal_id}, now(), now());
    ${id} =    Get Id Of Last Inserted Item
    Disconnect
    RETURN    ${id}

Remove User By Id Through Database
    [Arguments]    ${id}
    Connect
    Execute Sql String    DELETE FROM users WHERE id = ${id};
    Disconnect

Create Group Through Database
    [Arguments]    ${org_id}    ${name}    ${external_id}    ${description}    ${visibility}
    ${org_id} =    Normalize Value    ${org_id}
    ${name} =    Normalize Value    ${name}
    ${external_id} =    Normalize Value    ${external_id}
    ${description} =    Normalize Value    ${description}
    ${visibility} =    Normalize Value    ${visibility}
    Connect
    Execute Sql String
    ...    INSERT INTO `groups` (`org_id`, `name`, `external_id`, `description`, `start_date`, `end_date`, `apply_to_members`, `text`, `visibility`, `read_only`, `password`, `deleted_at`, `created_at`, `updated_at`) VALUE(${org_id}, ${name}, ${external_id}, ${description}, NULL, NULL, '0', NULL, ${visibility}, '0', NULL, NULL, now(), now());
    ${id} =    Get Id Of Last Inserted Item
    Disconnect
    RETURN    ${id}

Remove Group By Id Through Database
    [Arguments]    ${id}
    Connect
    Execute Sql String    DELETE FROM groups WHERE id = ${id};
    Disconnect

Enroll User To Group Through Database
    [Arguments]    ${group_id}    ${user_id}
    ${group_id} =    Normalize Value    ${group_id}
    ${user_id} =    Normalize Value    ${user_id}
    Connect
    Execute Sql String
    ...    INSERT INTO `group_user` (`group_id`, `user_id`, `type`, `created_at`, `updated_at`) VALUES (${group_id}, ${user_id}, '1', now(), now());
    ${id} =    Get Id Of Last Inserted Item
    Disconnect
    RETURN    ${id}

Normalize Value
    [Arguments]    ${value}
    IF    '${value}' == 'NULL' or '${value}' == 'null' or '${value}' == '${null}'
        ${result} =    Set Variable    NULL
    ELSE IF    '${value}' == 'now()'
        ${result} =    Set Variable    now()
    ELSE
        ${result} =    Set Variable    '${value}'
    END
    RETURN    ${result}

Get Id Of Last Inserted Item
    ${output} =    Query    Select LAST_INSERT_ID()
    RETURN    ${output[0][0]}

Set Dashboard Optout For UI
    [Arguments]    ${value}    ${organisation_id}
    Connect
    Execute Sql String
    ...    UPDATE curatr_v3.service_settings SET value=${value} WHERE org_id=${organisation_id} AND name='dashboard_opt_out';
    Disconnect

Set Default Org Positions Settings
    Connect
    Execute Sql String
    ...    UPDATE org_position_settings SET `entity1_id` = '17', `entity1_name` = 'Position', `entity2_id` = '1', `entity2_name` = 'Location' WHERE id=1;
    Disconnect

Set Empty Org Positions Settings
    Connect
    Execute Sql String
    ...    UPDATE org_position_settings SET `entity1_id` = NULL, `entity1_name` = NULL, `entity1_external_id` = NULL, `entity1_helptext` = NULL, `entity2_id` = NULL, `entity2_name` = NULL, `entity2_external_id` = NULL, `entity2_helptext` = NULL WHERE id=1;
    Disconnect
