cookbook_file "/root/gearman_spot.sh" do
	source "gearman_spot.sh"
	owner "root"
	group "root"
	mode  "0700"
	action :create
end

bash "Wait for spot termination notice" do
    code <<-EOH
    nohup bash /root/gearman_spot.sh &
    EOH
end
