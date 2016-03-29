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
recipe "raven-gearman::spot_instance", "Checks for Spot termination notice and shuts down"
