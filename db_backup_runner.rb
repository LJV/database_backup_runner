# Usage: bundle exec ruby db_backup_runner.rb /path/to/config.yml
#
# From cron: /bin/bash -l -c 'cd /path/to/backup_runner/ && bundle exec ruby backup_runner.rb /path/to/config.yml' >> /path/to/log.log 2>&1
#
# This will dump the specific database to gzipped sql file,
# clean up old dumps, and then upload the new dump to the 
# specified Rackspace container

require 'database_backup'
require 'rackspace_uploader'

puts "#{Time.now}: Loading Config from #{ARGV[0]}"

CONFIG = YAML.load_file(ARGV[0])

puts "#{Time.now}: Starting database dump"

b = LJV::DatabaseBackup.new(:db_username => CONFIG['db_username'], :db_password => CONFIG['db_password'], :db_name => CONFIG['db_name'], :backup_dir => CONFIG['backup_dir'], :num_backups => CONFIG['num_backups'])
dump_file = b.backup!
result = b.cleanup!
      
puts "#{Time.now}: Deleted #{result[:deleted_backups]} backups, #{result[:remaining_backups]} backups remaining" 
puts "#{Time.now}: Uploading #{dump_file} to #{File.basename(dump_file)}..."

u = LJV::RackspaceUploader.new(:username => CONFIG['rackspace_username'], :api_key => CONFIG['rackspace_api_key'])
u.upload(dump_file, CONFIG['rackspace_container'], File.basename(dump_file))

puts "#{Time.now}: Upload complete"



