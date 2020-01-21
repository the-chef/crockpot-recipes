#!/bin/bash
curl -OJ "https://github.com/the-chef/crockpot-recipes/raw/master/NessusAgent-7.5.1-es7.x86_64.rpm"
rpm -Uvh NessusAgent*.rpm
/opt/nessus_agent/sbin/nessuscli agent link --key=c96e52d76984b1fefe7183284ca57d0b31bcd0b04ce50f244c78196389e28a67 --groups="AWS, Linux, RHEL7" --host=cloud.tenable.com --port=443
systemctl start nessusagent.service

