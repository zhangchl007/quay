#!/bin/bash
#date:2019-01-22
# set repo sync 

src_api=quay01.test01.com
dst_api=quay02.test01.com
SRC_ACCESS_TOKEN=GDDimU3JNpDM1sYyIHepPyuqXKAdXRaoVN8bMAyD
DST_ACCESS_TOKEN=IhqP3PjI2oM9LR2fwFhUCfupJQ2qe2oI1JLi8Blr

usage(){
echo "Usage: deploy quay repo sync!"
}

# create org

create_org() {

for org in `curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/find/repositories" |jq -r '.results[].namespace.href' | awk -F'/' '{print $3}' | sort -u`
do 
    curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${DST_ACCESS_TOKEN}"  "https://$dst_api/api/v1/organization/" \
--data  @<(cat <<EOF
{
  "name": "$org"
}
EOF
)
   #curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer ${DST_ACCESS_TOKEN}"  "https://$dst_api/api/v1/organization/$org"
done
}

# create robot account

create_robot() {

for org in `curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/find/repositories" |jq -r '.results[].namespace.href' | awk -F'/' '{print $3}' | sort -u`
do 
    curl -X PUT -H "Authorization: Bearer ${SRC_ACCESS_TOKEN}" "https://$src_api/api/v1/organization/$org/robots/mirrorsa"
done
}

set_repo_robot() {
    for repos in `curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/find/repositories" | jq -r '.results[].href'`
    do 
         org=`echo $repos | awk -F'/' '{print $3}'`
         repo=`echo $repos | awk -F'/' '{print $4}'`
         curl -H "Content-Type: application/json" -L -s -X PUT -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/repository/$org/$repo/permissions/user/$org+mirrorsa" -d '{"role":"write"}'
   done

}

set_reposync() {
for repos in `curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/find/repositories" | jq -r '.results[].href'`
do 
    org=`echo $repos | awk -F'/' '{print $3}'`
    repo=`echo $repos | awk -F'/' '{print $4}'`
     
    curl -H "Content-Type: application/json" -L -s -X PUT -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/repository/$org/$repo/changestate" \
    -d '{"state":"MIRROR"}'
    #curl -H "Content-Type: application/json" -L -s -X PUT -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/repository/$org/$repo/changestate" \
    #-d '{"state":"NORMAL"}'
    curl -H "Content-Type: application/json" -L -s -X POST -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/repository/$org/$repo/mirror"  \
--data  @<(cat <<EOF
{
"external_reference": "$dst_api/$org/$repo",
"external_registry_username": "admin",
"external_registry_password": "New.xxxxx760",
"sync_interval": 1200,
"sync_start_date": "2021-12-10T14:20:00Z",
"robot_username": "$org+mirrorsa",
"external_registry_config": {
"verify_tls": true,
"proxy": {
"http_proxy": null,
"https_proxy": null,
"no_proxy": null}},
"root_rule": {
"rule_kind": "tag_glob_csv",
"rule_value": ["*"]
}}
EOF
)
done
}

reposync_skopeo() {

curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/find/repositories" | jq -r '.results[].namespace.avatar'
}

create_org
#create_robot
#set_repo_robot
#set_reposync
