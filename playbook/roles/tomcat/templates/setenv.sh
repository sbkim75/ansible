CATALINA_OUT="/logs/tomcat/catalina.out"

{% if java_opts is defined %}
JAVA_OPTS="{{ java_opts }}"
{% endif %}

{% if classpath is defined %}
CLASSPATH="{{ classpath }}"
{% endif %}

{% if ld_library_path is defined %}
LD_LIBRARY_PATH="{{ ld_library_path }}"
export LD_LIBRARY_PATH
{% endif %}

{% if umask_value is defined %}
export UMASK="{{ umask_value }}"
{% endif %}

