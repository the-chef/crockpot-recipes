#!/bin/bash
subscription-manager clean
yum clean all
rm -f /etc/yum.repos.d/*.repo
wget -O /etc/yum.repos.d/rhel7-Non-Prod.repo https://raw.githubusercontent.com/the-chef/crockpot-recipes/master/rhel7-Non-Prod.repo
yum check-update
