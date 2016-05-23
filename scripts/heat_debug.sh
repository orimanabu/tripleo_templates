#!/bin/bash

source ~/stackrc

echo "=> instack-ironic-deployment --show-profile"
instack-ironic-deployment --show-profile

echo "=> ironic node-list"
ironic node-list

echo "=> ironic node-show"
for id in $(ironic node-list | grep None | awk '{print $2}'); do
        echo "==> ironic node-show ${id}"
	ironic node-show ${id}
        echo "==> ironic node-post-list ${id}"
	ironic node-port-list ${id}
done

echo "=> nova list"
nova list
for id in $(nova list | awk '/ERROR/ {print $2}'); do
	echo "==> nova show ${id}"
	nova show ${id}
done

echo "=> nova flavor-list"
nova flavor-list
echo "=> nova flavor-show control"
nova flavor-show control
echo "=> nova flavor-show compute"
nova flavor-show compute

echo "=> heat stack-show overcloud"
heat stack-show overcloud

echo "=> heat stack-list --show-nested"
heat stack-list --show-nested

echo "=> heat stack-list --show-nested | grep FAIL"
heat stack-list --show-nested | grep FAIL

echo "=> heat resource-list -n 5 overcloud"
heat resource-list -n 5 overcloud

echo "=> heat resource-list -n 5 overcloud | grep FAIL"
heat resource-list -n 5 overcloud | grep FAIL

#names=""
#heat resource-list -n 5 overcloud | grep FAIL | while read line; do
#	name=$(echo "${line}" | awk '{print $2}')
#	id=$(echo "${line}" | awk '{print $4}')
#	key=$(echo "${line}" | awk '{print $12}')
#	names="${names} ${name}"
#	echo "* ${names}"
#	export names
#done
#echo "** ${names}"

echo "=> heat resource-show ..."
heat resource-list -n 5 overcloud | grep FAIL | while read line; do
	name=$(echo "${line}" | awk '{print $2}')
	id=$(echo "${line}" | awk '{print $4}')
	key=$(echo "${line}" | awk '{print $12}')
#	echo "* name: ${name}, id: ${id}, key: ${key}"
	echo "${line}" | grep -E 'OS::Heat::(ResourceGroup|StructuredDeployments)' > /dev/null 2>&1
	if [ x"$?" = x"0" ]; then
		echo "==> heat resource-show ${id} 0"
		heat resource-show ${id} 0
		echo "==> heat resource-show ${id} 1"
		heat resource-show ${id} 1
		echo "==> heat resource-show ${id} 2"
		heat resource-show ${id} 2
#		for n in ${names}; do
#			echo "n: $name"
#			if [ x"$key" = x"$n" ]; then
#				heat resource-show ${id} ${name}
#			fi
#		done
	fi
done

echo "=> heat deployment-show ..."
for failed_deployment in $(heat resource-list --nested-depth 5 overcloud | grep FAILED | grep 'StructuredDeployment ' | cut -d '|' -f3); do
	echo "==> heat deployment-show ${failed_deployment}"
	heat deployment-show $failed_deployment
done

# heat resource-list -n5 overcloud | grep Deployment | grep FAILED
