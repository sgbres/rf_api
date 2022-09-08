*** Settings ***
Documentation       Project global configuration variables

*** Variables ***
${ORG_ID}                       1
${ORG_ALIAS}                    qa

${BASE_URL}                     https://${ORG_ALIAS}.curatr3.com

${AUTHENTICATION_ENDPOINT}      /lxp/api/v1/user/token
${USERS_ENDPOINT}               /lxp/api/v1/users

${ORG_ADMIN_USERNAME}           orgadmin
${GLOBAL_PASSWORD}              welcome1
${SUPER_ADMIN}                  qasuperadmin@noreply.com

${ADMIN_AUTH_JSON}              {"username": "${ORG_ADMIN_USERNAME}",
...                             "password": "${GLOBAL_PASSWORD}",
...                             "administer_org_id": ${ORG_ID}}

${USER_AUTH_JSON}               {"username": "steve@learningpool.com",
...                             "password": "${GLOBAL_PASSWORD}",
...                             "administer_org_id": ${ORG_ID}}

# db configuration
${DB_NAME}                      curatr_v3
${DB_USERNAME}                  root
${DB_PASSWORD}                  ${EMPTY}
${DB_HOST}                      db
${DB_PORT}                      3306
