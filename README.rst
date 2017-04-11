
==============
Moodle Formula
==============

Moodle is a Course Management System (CMS), also known as a Learning
Management System (LMS) or a Virtual Learning Environment (VLE). It is
a Free web application that educators can use to create effective online
learning sites.

Sample Pillars
==============

.. code-block:: yaml

    moodle:
      enabled: true
      apps:
      - enabled: true
        name: 'uni'
        prefix: 'uni_' # max 5 chars
        version: '2.5'
        database:
          engine: 'postgresql'
          host: '127.0.0.1'
          name: 'moodle_uni'
          password: 'pwd'
          user: 'moodle_uni'
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
        themes:
        - name: uni
          source:
            type: git
            address: git@repo.git.cz:domain/repo.git
            branch: master

More Information
================

* https://moodle.org/plugins/view.php?plugin=cachestore_apc
* http://midact.com/content/moodle-how-enable-memcached
* http://docs.moodle.org/dev/The_Moodle_Universal_Cache_%28MUC%29
* http://docs.moodle.org/24/en/Cron
