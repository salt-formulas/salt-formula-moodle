<?PHP

unset($CFG);
global $CFG;
$CFG = new stdClass();

{%- from "apache/map.jinja" import server with context %}
{%- set app = salt['pillar.get']('moodle:server:app:'+app_name) %}
{%- set site = salt['pillar.get']('apache:server:site:moodle_'+app_name) %}

$CFG->dbtype    = '{%- if app.database.engine == "mysql" %}mysqli{% else %}pgsql{%- endif %}';
$CFG->dblibrary = 'native';
$CFG->dbhost    = '{{ app.database.host }}';
$CFG->dbname    = '{{ app.database.name }}';
$CFG->dbuser    = '{{ app.database.user }}';
$CFG->dbpass    = '{{ app.database.password }}';
$CFG->dboptions = array (
  'dbpersist' => false,
  'dbsocket' => false,
  'dbport' => '',
);

$CFG->prefix    = '{{ app.database.get('prefix', app_name) }}_';

$CFG->wwwroot   = 'http://{{ site.host.name }}';

$CFG->dataroot  = '/srv/moodle/sites/{{ app_name }}/data';

$CFG->dirroot = '/srv/moodle/sites/{{ app_name }}/root';

$CFG->directorypermissions = 02777;

$CFG->admin     = 'admin';

$CFG->passwordsaltmain = '0:%ZPidr)CNfX(R.EVRcS4~Q/CbP';

{% if app.cache is defined %}
//$CFG->cachetype='{{ app.cache.engine }}';
//$CFG->rcache = true;
//$CFG->memcachedhosts= '{{ app.cache.host }}';
//$CFG->memcachedpconn=true;
{% endif %}

$CFG->themedir = '/srv/moodle/sites/{{ app_name }}/theme';

// $CFG->disableupdateautodeploy = true;

require_once(dirname(__FILE__) . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
