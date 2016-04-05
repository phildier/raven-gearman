#!/bin/bash
while true; do
        if [ -z $(curl -Is http://169.254.169.254/latest/meta-data/spot/termination-time | head -1 | grep 404 | cut -d' ' -f 2) ]; then
				if [ ! -f /tmp/halt_workers ]; then 
					INSTANCE_ID="`curl -s http://instance-data/latest/meta-data/instance-id`"
					NAME=`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --region us-east-1 --output=text |cut -f5`
					curl -X POST --data-urlencode "payload={\"channel\": \"devops\", \"username\": \"awsinfo\", \"text\": \"Spot instance $NAME shutting down\", \"icon_emoji\": \":aws:\"}" https://hooks.slack.com/services/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
				fi
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
