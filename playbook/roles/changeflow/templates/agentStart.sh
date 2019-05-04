#!/bin/sh

echo "Validating the $USER ..."

if [ $USER == "{{ install_user }}" ]
then
    sh {{ install_dir }}/CFAgent/agent/agent.sh & > /dev/null
    ps -ef | grep '{{ install_dir }}/CFAgent/agent/agent.sh' | grep -v grep | awk '{print $2}' > {{ log_dir }}/Agent.pid
else
    echo "Error : {{ install_user }} 계정으로만 실행 가능합니다."
    exit -1
fi
