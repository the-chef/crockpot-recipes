#!/bin/bash
subscription-manager clean
yum clean all
rm -f /etc/yum.repos.d/*.repo
/bin/cp -f /Linux_Install_CDs/hardening/rhel7-Prod.repo /etc/yum.repos.d/
yum check-update
