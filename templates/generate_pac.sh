#!/bin/bash
SAVEPATH={{ pac_file_save_path }}
# Create Proxy PAC-File with cronjob
# Command: /usr/local/dvag_scripts/pac_generator.sh o365 > /var/www/pac.vhost/proxy.pac
echo "// Ansible Managed File" | tee -a $SAVEPATH
echo "function FindProxyForURL(url, host)" | tee -a $SAVEPATH
echo "  {" | tee -a $SAVEPATH
echo "  //set variables" | tee -a $SAVEPATH
echo "  var client = myIpAddress();" | tee -a $SAVEPATH
echo "  var direct = \"DIRECT\";" | tee -a $SAVEPATH
{% if pac_file_proxys | length > 0 %}
{%  for proxy in pac_file_proxys %}
echo "  var {{ proxy.name }} = \"PROXY {{ proxy.address }}\";" | tee -a $SAVEPATH
{%  endfor%}
{% endif %}
echo " " | tee -a $SAVEPATH
echo "  // defined rules" | tee -a $SAVEPATH
{% if pac_file_rules | length > 0 %}
{%  for rule in pac_file_rules %}
echo "  if ({{ rule.type }}(host, {{ rule.name }})) { return {{ rule.return }}; }" | tee -a $SAVEPATH
{%  endfor%}
{% endif %}
echo " " | tee -a $SAVEPATH
echo " " | tee -a $SAVEPATH
echo "  // return proxy for any not defined acls" | tee -a $SAVEPATH
echo "  return proxy;" | tee -a $SAVEPATH
echo "}" | tee -a $SAVEPATH
