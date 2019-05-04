#!/bin/sh

{% if usePETRA is defined and usePETRA == "True" %}
# PetraSafer LIB PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/petra
export PC_CONF_FILE=/sw/petra/petra_cipher_api.conf
{% endif %}

{% if useNFILTER is defined and useNFILTER == "True" %}
# NSHC nfilter LIB PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/nshc/nfilter
{% endif %}

{% if useKCB is defined and useKCB == "True" %}
# KCB LIB PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/kcb/java64_glibc2.12
{% endif %}

{% if useRAON is defined and useRAON == "True" %}
# RAONSECURE PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/raon/ksbiz2/lib
export KSBIZ_CONF_PATH=/sw/raon/ksbiz2/conf/ksbiz.conf
{% endif %}

{% if useINZI is defined and useINZI == "True" %}
# INZISOFT CRYPTO PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/sw/inzi/crypto/lib
{% endif %}
