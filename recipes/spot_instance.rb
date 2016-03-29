file "/root/gearman_spot.sh" do
	content <<-EOH
#!/bin/bash 
while true; do 
	if [ -z $(curl -Is http://169.254.169.254/latest/meta-data/spot/termination-time | head -1 | grep 404 | cut -d' ' -f 2) ]; then
		touch /tmp/halt_workers
		until [ "$(ps aux | grep "[p]hp gearman_worker" | wc -l)" -lt 1 ]; do
   			touch /tmp/halt_workers;
	   		sleep 1;
		done
		rs_shutdown --terminate
	else
		sleep 5
	fi
done
EOH
end

bash "Wait for spot termination notice" do
    code <<-EOH
    nohup bash /root/gearman_spot.sh &
    EOH
end
