{%- from "moodle/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- php.environment

moodle_packages:
  pkg.installed:
  - names:
    - php5-mysql
    - php5-pgsql
    - php5-gd
    - php5-curl
    - php5-intl
    - php5-xmlrpc
    - php5-mcrypt
    - php5-dev
    - php5-memcache
  - require:
    - pkg: php_packages

/srv/moodle:
  file.directory:
  - user: root
  - group: www-data
  - mode: 755
  - makedirs: true

{%- endif %}