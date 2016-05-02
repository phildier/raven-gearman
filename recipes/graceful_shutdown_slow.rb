ruby_block "Halting Gearman Worker" do
	block do 
		::FileUtils.touch "/tmp/halt_workers_slow"
	end
end

file "/root/gearman_worker_wait_slow.sh" do
	content <<-EOH
#!/bin/bash -ex

touch /tmp/halt_workers_slow
until [ "$(ps aux | grep "[p]hp gearman_worker" | wc -l)" -lt 1 ]; do
    touch /tmp/halt_workers_slow
    sleep 1;
done
rs_shutdown --terminate
	EOH
end

bash "Wait for all workers to exit" do
    code <<-EOH
    nohup bash /root/gearman_worker_wait_slow.sh &
    EOH
end
