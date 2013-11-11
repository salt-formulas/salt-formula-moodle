{%- if pillar.moodle.server.enabled %}

include:
- php
- git

/srv/moodle:
  file:
  - directory
  - user: root
  - group: root
  - mode: 755
  - makedirs: true

{%- for app in pillar.moodle.server.apps %}

/srv/moodle/sites/{{ app.name }}/data:
  file:
  - directory
  - user: www-data
  - group: www-data
  - mode: 777
  - makedirs: true

moodle_{{ app.name }}_git:
  git.latest:
  - name: git://git.moodle.org/moodle.git
  - rev: MOODLE_{{ app.version|replace(".", "") }}_STABLE
  - target: /srv/moodle/sites/{{ app.name }}/root
  - require:
    - pkg: git_packages

/srv/moodle/sites/{{ app.name }}/root/config.php:
  file:
  - managed
  - source: salt://moodle/conf/config.php
  - template: jinja
  - mode: 644
  - require:
    - git: moodle_{{ app.name }}_git
  - defaults:
    app_name: "{{ app.name }}"

{%- if app.themes is defined %}

{%- for theme in app.themes %}

{%- if theme.source.type == 'git' %}

moodle_{{ app.name }}_theme_{{ theme.name }}:
  git.latest:
  - name: {{ theme.source.address }}
  - target: /srv/moodle/sites/{{ app.name }}/root/theme/{{ theme.name }}
  {%- if theme.source.branch is defined %}
  - rev: {{ theme.source.branch }}
  {%- endif %}
  - require:
    - git: moodle_{{ app.name }}_git

{%- endif %}

{%- endfor %}

{%- endif %}

{%- endfor %}

{%- endif %}
