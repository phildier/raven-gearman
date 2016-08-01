name             'raven-gearman'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures raven-gearman'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "raven-gearman::default", "install gearman and dependencies"
recipe "raven-gearman::master", "run gearmand server"
recipe "raven-gearman::dev", "install gearman build script"
recipe "raven-gearman::graceful_shutdown", "gracefully shut down server"
recipe "raven-gearman::graceful_shutdown_slow", "gracefully shut down server slow"
recipe "raven-gearman::spot_instance", "Checks for Spot termination notice and shuts down"

attribute "raven_gearman",
	:display_name => "Raven Gearman",
	:type => "hash"

attribute "raven_gearman/memcached_servers",
	:display_name => "Memcached server for gearman",
	:description => "Memcached server for gearman",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-gearman::master"],
	:default => "127.0.0.1"

attribute "raven_gearman/master",
	:display_name => "Install gearmand",
	:description => "Install gearmand",
	:required => "recommended",
	:type => "string",
	:recipes => ["raven-gearman::master"],
	:default => "false"

attribute "raven_gearman/slack/webhookurl",
	:display_name => "Slack webhook URL",
	:description => "Slack webhook URL",
	:required => "required",
	:type => "string",
	:recipes => ["raven-gearman::spot_instance"]

attribute "raven_gearman/slack/channel",
	:display_name => "Slack channel",
	:description => "Slack channel",
	:required => "required",
	:type => "string",
	:recipes => ["raven-gearman::spot_instance"]

attribute "raven_gearman/slack/botname",
	:display_name => "Slack botname",
	:description => "Slack botname",
	:required => "required",
	:type => "string",
	:recipes => ["raven-gearman::spot_instance"]
