#!/bin/sh
export HTTPD_MAIN_HOSTS=( {{ httpd_main_hosts }} )
export HTTPD_HOSTS=( {{ httpd_hosts }} )
export BIND_ADDR={{ ansible_eth0.ipv4.address }}
export LB_WORKER={{ lb_worker }}
export WORKER={{ worker }}
export AJP_PORT={{ ajp_port }}
{% if http_port is defined and http_port is not none %}
export HTTP_PORT={{ http_port }}
{% endif %}
export CONTEXT_NAME={{ context_name }}

