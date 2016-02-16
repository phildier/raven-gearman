#!/bin/bash


###
# Builds gearman from source
# Package provides gearman binary and libgearman/devel for building gearman clients
#
build_gearmand() {

	if [ -f gearman-1.1.12-1.x86_64.rpm ]; then
		echo "found gearman rpm. delete it to rebuild"
		return 0
	fi

	rm -rf /root/gearman_tmp
	mkdir /root/gearman_tmp

	yum -y install boost-devel
	yum -y install libevent-devel
	yum -y install libuuid-devel
	yum -y install mysql-devel
	yum -y install libmemcached-devel

	if [ ! -f gearmand-1.1.12.tar.gz ]; then
		wget https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz
	fi

	if [ ! -f gearmand-1.1.12 ]; then
		tar xfz gearmand-1.1.12.tar.gz
	fi

	pushd gearmand-1.1.12
	CFLAGS="$CFLAGS -lpthread" ./configure --prefix=/usr
	make
	make install DESTDIR=/root/gearman_tmp

	popd

	pushd /root/gearman_tmp

	echo "ldconfig" > ldconfig.sh
	chmod 755 ldconfig.sh

	fpm -s dir -t rpm -v 1.1.12 --iteration 2 -n gearman --after-install ldconfig.sh usr
	mv gearman-1.1.12-1.x86_64.rpm ..
	popd

	yum -y erase gearman
	rpm -i gearman-1.1.12-1.x86_64.rpm
	
	return $?
}


###
# Builds php pecl gearman package.  
# Requires build_gearmand() to be run successfully first
#
build_pecl_gearman() {

	if [ ! -f pecl-gearman-1.1.2.tgz ]; then
		wget http://chefattachments.s3.amazonaws.com/pecl-gearman-1.1.2.tgz
	fi

	if [ ! -f gearman-1.1.2 ]; then
		tar xf pecl-gearman-1.1.2.tgz
	fi
	ver=`php -v |head -1 |awk '{print $2}' |awk -F. '{print $1 $2}'`

	yum -y install php${ver}u-devel

	pushd gearman-1.1.2
	phpize
	./configure
	make
	mkdir -p etc/php.d
	echo "extension=gearman.so" > etc/php.d/gearman.ini
	mkdir -p usr/lib64/php/modules/
	cp modules/gearman.so usr/lib64/php/modules/
	fpm -s dir -t rpm -n php${ver}u-pecl-gearman -v 1.1.2 etc usr
	mv php${ver}u-pecl-gearman-1.1.2-1.x86_64.rpm ..
	popd

	yum -y erase php${ver}u-pecl-gearman
	rpm -i php${ver}u-pecl-gearman-1.1.2-1.x86_64.rpm

	return $?
}

build_gearmand
build_pecl_gearman
