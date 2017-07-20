#!/bin/sh

{%- set app = salt['pillar.get']('moodle:server:app:'+app_name) %}
{%- if app.initial_data is defined %}

scp -r backupninja@{{ app.initial_data.source }}:/srv/backupninja/{{ app.initial_data.host }}/srv/moodle/sites/{{ app.initial_data.get('app', app_name) }}/data/data.0/* /srv/moodle/sites/{{ app_name }}/data
cd /srv/moodle/sites/{{ app_name }}
chown www-data:www-data ./data -R
php ./root/admin/cli/purge_caches.php
touch /root/moodle/flags/{{ app_name }}-installed

{%- endif %}