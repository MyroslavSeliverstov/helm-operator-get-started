#!/usr/bin/env bash

repository="quay.io/myroslavseliverstov/porter"
commit=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1 | awk '{print tolower($0)}')
build_num=( $(<build_numb.txt) )
build_num=$(( build_num + 1 ))
echo ${build_num} > build_numb.txt

echo ">>>> Building image <<<<"

docker build --build-arg BUNDLE_DIR=/cnab/app -t ${repository}:dev-${commit} .
docker tag ${repository}:dev-${commit} ${repository}:0.1.${build_num}

echo ">>>> Push image ${repository}:dev-${commit} <<<<"
docker push ${repository}:dev-${commit}

echo ">>>> Push image ${repository}:0.1.${build_num} <<<<"
docker push ${repository}:0.1.${build_num}
