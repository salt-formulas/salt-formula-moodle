<?php

unset($CFG);
global $CFG;
$CFG = new stdClass();

{%- for app in pillar.moodle.apps %}
{%- if app_name == app.name %}
$CFG->dbtype    = '{%- if app.database.engine == "mysql" %}mysql{% else %}pgsql{%- endif %}';
$CFG->dblibrary = 'native';
$CFG->dbhost    = '{{ app.database.host }}';
$CFG->dbname    = '{{ app.database.name }}';
$CFG->dbuser    = '{{ app.database.user }}';
$CFG->dbpass    = '{{ app.database.password }}';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbsocket' => '',
);

{% if app.prefix is defined %}
$CFG->prefix    = '{{ app.prefix }}_';
{% else %}
$CFG->prefix    = 'mdl_';
{% endif %}

{%- for site in pillar.apache.sites %}
{%- if app_name == site.site_name %}
$CFG->wwwroot   = 'http://{{ site.server_name }}';
{%- endif %}
{%- endfor %}
$CFG->dataroot  = '/srv/moodle/sites/{{ app.name }}/data';
$CFG->dirroot = '/srv/moodle/sites/{{ app.name }}/root';
$CFG->admin     = 'admin';

$CFG->directorypermissions = 0777;
$CFG->passwordsaltmain = '0:%ZPidr)CNfX(R.EVRcS4~Q/CbP';

{% if app.cache is defined %}
$CFG->cachetype='{{ app.cache.engine }}';
$CFG->rcache = true;
$CFG->memcachedhosts= '{{ app.cache.host }}';
$CFG->memcachedpconn=true;
{% endif %}

require_once(dirname(__FILE__) . '/lib/setup.php');
{%- endif %}
{%- endfor %}

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
