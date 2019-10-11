#!/bin/bash

function dummy_commit {
	sed -i 's/simple/sample/' Readme.md
	git add Readme.md
	git commit -m "Simple is sample
	
	* Here I added lines
	* And that feels good
	"

	sed -i 's/sample/simple/' Readme.md
	git add Readme.md
	git commit -m "Sample is simple
	
	* Here I added lines
	* And that feels good
	"
}

function user_commit {
	sed -i 's/simple/sample/' Readme.md
	git add Readme.md
	git commit -m "Simple is sample
	
	* Here I added lines
	* And that feels good
	* Isn't it, $1
	"

	sed -i 's/sample/simple/' Readme.md
	git add Readme.md
	git commit -m "Sample is simple
	
	* Here I added lines
	* And that feels good
	"
}
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

if [ "$PWD" == "$SCRIPTPATH" ]
then
	echo "This script is meant to be executed from repository root"
	echo "Move to this repository root folder and execute this script again"
	exit 1
fi

readarray user_list < setup/jenkins/jenkinscred.list
user_count=0
total_user=${#user_list[@]}

echo "This is simple" >> Readme.md
git add Readme.md
git commit -m "This is simple"

while [ ${user_count} -lt ${total_user} ]
do
	random=$(shuf -i 1-20 -n 1)
	
	if [ ${random} -gt 17 ]
	then
		user_commit ${user_list[${user_count}]}
		user_count=$((user_count + 1))
	else
		dummy_commit
	fi
done

for i in {1..60}
do
	dummy_commit
done

# Remove last line of readme "This is simple"
sed -i '$ d' Readme.md
git add Readme.md
git commit -m "Remove dummy line"

exit 0
