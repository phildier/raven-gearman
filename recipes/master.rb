if node[:raven_gearman][:master].to_s == "true" then

    user "gearman" do
        system true
        shell "/bin/false"
        action :create
    end

    gearmand_wdir = "/var/run/gearman"
    directory gearmand_wdir do
        action :create
        user "gearman"
        mode 0755
    end

	memcached_servers = node[:raven_gearman][:memcached_servers]

	cmd = "gearmand --pid-file=#{gearmand_wdir}/gearmand.pid --log-file=stderr --round-robin --job-retries=1 --queue-type=libmemcached --libmemcached-servers=#{memcached_servers} --listen 0.0.0.0"
	raven_supervisor_program "gearmand" do
		command cmd
		directory gearmand_wdir
		user "gearman"
	end
end
