database_backup_runner
======================

Simple Ruby script to dump a MySQL database and upload the dump file to Rackspace CloudFiles

Clone a local copy and execute as follows:

    bundle exec ruby database_backup_runner.rb /path/to/config.yml
    
Look in sample_config.yml for the various credentials/options you need to setup

If you want to run from cron, something like the following might work well:

    0 12 * * * /bin/bash -l -c 'cd /path/to/backup_runner/ && bundle exec ruby backup_runner.rb /path/to/config.yml' >> /path/to/log.log 2>&1
