CATALINA_OUT="/logs/tomcat/{{ instance_nm }}/catalina.out"

{% if java_opts is defined and java_opts != '' %}
JAVA_OPTS="{{ java_opts }}"
{% endif %}

{% if classpath is defined and classpath != '' %}
CLASSPATH="{{ classpath }}"
{% endif %}

{% if ld_library_path is defined and ld_library_path != '' %}
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:{{ ld_library_path }}"
export LD_LIBRARY_PATH

{% if ld_library_path == '/sw/petra' %}
export PC_CONF_FILE="{{ ld_library_path }}/petra_cipher_api.conf"
{% endif %}

{% endif %}

{% if umask_value is defined and umask_value != '' %}
export UMASK="{{ umask_value }}"
{% endif %}

