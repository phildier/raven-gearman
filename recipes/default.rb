# install gearman and dependencies
%w(
	uuid
	libuuid
	libevent
	gperf
	boost
).each do |p|
	package p
end

package "gearman" do
	version "1.1.12-2"
end

package "php56u-pecl-gearman"

package "libmemcached" do
	version "1.0.16-1.el6.art"
end
