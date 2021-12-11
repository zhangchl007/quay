#!/bin/bash
#date:2019-01-22
# set repo sync 

src_api=quay01.test01.com
dst_api=quay02.test01.com
SRC_ACCESS_TOKEN=GDDimU3JNpDM1sYyIHepPyuqXKAdXRaoVN8bMAyD
DST_ACCESS_TOKEN=IhqP3PjI2oM9LR2fwFhUCfupJQ2qe2oI1JLi8Blr
array1=()

usage(){
echo "Usage: deploy quay repo sync!"
}

# create org

create_org() {
str=""
arry=("|" "/" "-" "\\")
j=0
for i in `seq 1 20`
do 
   for org in `curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/find/repositories?page=$i" |jq -r '.results[].namespace.href' | awk -F'/' '{print $3}' | sort -u`
  do 
      let j++ 
      if [[ "${array1[@]}" =~ "$org" ]];then
           echo "$org exists in a1 array!"
      else
           array1[$j]=$org
           echo "creating the organization: $org for $dst_api!"
           curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${DST_ACCESS_TOKEN}"  "https://$dst_api/api/v1/organization/" \
           -d  "{\"name\": \"$org\" }" 
          #curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer ${DST_ACCESS_TOKEN}"  "https://$dst_api/api/v1/organization/$org"
      fi
  done
  let index=i%2
  printf "%3d%% %c%-20s%c\r" "$i" "${arry[$index]}" "$str" "${arry[$index]}"
  let i=i+4
  str+="**"
  echo "Please be patient!" 
done
}

sync_images() { 

for org in "${array1[@]}"
do
      imglist=`curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/repository?namespace=$org" | jq -r .repositories[].name |sort -u`
      for imgname in $imglist
      do 
          taglist=`curl -H "Content-Type: application/json" -L -s -X GET -H "Authorization: Bearer $SRC_ACCESS_TOKEN" "https://$src_api/api/v1/repository/$org/$imgname/tag" | jq -r ".tags[$count].name" |  sort -u`
          for tag in $taglist
          do 
            echo "src: $src_api/$org/$imgname:$tag  dest: $dst_api/$org/$imgname:$tag"
            skopeo --debug --insecure-policy copy --all --authfile=./mypullsecret.json --dest-tls-verify=false docker://$src_api/$org/$imgname:$tag docker://$dst_api/$org/$imgname:$tag
          done
       done
done 
}
create_org
sync_images
