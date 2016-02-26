ruby_block "Halting Gearman Worker" do
	block do 
		::FileUtils.touch "/tmp/halt_workers"
	end
end

file "/root/gearman_worker_wait.sh" do
	content <<-EOH
#!/bin/bash -ex

touch /tmp/halt_workers
until [ "$(ps aux | grep "[p]hp gearman_worker" | wc -l)" -lt 1 ]; do
    touch /tmp/halt_workers;
    sleep 1;
done
rs_shutdown --terminate
	EOH
end

bash "Wait for all workers to exit" do
    code <<-EOH
    nohup bash /root/gearman_worker_wait.sh &
    EOH
end
