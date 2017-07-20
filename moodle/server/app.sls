{%- from "moodle/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}

/srv/moodle/sites/{{ app_name }}/data:
  file.directory:
  - user: root
  - group: www-data
  - mode: 770
  - makedirs: true

/srv/moodle/sites/{{ app_name }}/theme:
  file.directory:
  - user: root
  - group: www-data
  - mode: 770
  - makedirs: true

moodle_{{ app_name }}_git:
  git.latest:
  - name: {{ server.git_source }}
  - rev: MOODLE_{{ app.version|replace(".", "") }}_STABLE
  - target: /srv/moodle/sites/{{ app_name }}/root 
  - require:
    - pkg: git_packages

/srv/moodle/sites/{{ app_name }}/root/config.php:
  file.managed:
  - source: salt://moodle/files/config.php
  - template: jinja
  - mode: 644
  - require:
    - git: moodle_{{ app_name }}_git
  - defaults:
    app_name: "{{ app_name }}"

{%- if app.theme is defined %}

moodle_{{ app_name }}_theme:
  git.latest:
  - name: {{ app.theme.address }}
  - target: /srv/moodle/sites/{{ app_name }}/theme/{{ app.theme.name }}
  - rev: {{ app.theme.get('branch', 'master') }}
  - require:
    - file: /srv/moodle/sites/{{ app_name }}/theme

{%- endif %}

{%- if app.initial_data is defined %}

/root/moodle/scripts/restore_{{ app_name }}.sh:
  file.managed:
  - user: root
  - group: root
  - source: salt://moodle/files/restore.sh
  - mode: 700
  - template: jinja
  - defaults:
    app_name: "{{ app_name }}"
  - require:
    - file: /root/moodle/scripts
    - file: /root/moodle/flags

restore_moodle_{{ app_name }}:
  cmd.run:
  - name: /root/moodle/scripts/restore_{{ app_name }}.sh
  - unless: "[ -f /root/moodle/flags/{{ app_name }}-installed ]"
  - cwd: /root
  - require:
    - file: /root/moodle/scripts/restore_{{ app_name }}.sh

{%- endif %}

{%- endfor %}

/root/moodle/scripts:
  file.directory:
  - user: root
  - group: root
  - mode: 700
  - makedirs: true

/root/moodle/flags:
  file.directory:
  - user: root
  - group: root
  - mode: 700
  - makedirs: true

{%- endif %}