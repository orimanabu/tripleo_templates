#!/bin/bash

source ~/stackrc
workdir=~/images_work
imagedir=~/images

#mkdir -p ${workdir}
#mkdir -p ${imagedir}
#
#image=CentOS-7-x86_64-GenericCloud.qcow2.xz
#mkdir -p ~/.cache/image-create
#scp ori@trevally.usersys.redhat.com:${image} ~/.cache/image-create/${image}

export NODE_DIST=centos7
export USE_DELOREAN_TRUNK=1
export DELOREAN_TRUNK_REPO="http://trunk.rdoproject.org/centos7-mitaka/current/"
export DELOREAN_REPO_FILE="delorean.repo"

cd ${workdir} && time openstack overcloud image build --all
#mv ${workdir}/{ironic-python-agent.initramfs,ironic-python-agent.kernel,ironic-python-agent.vmlinuz,overcloud-full.initrd,overcloud-full.qcow2,overcloud-full.vmlinuz} ${imagedir}
