#!/bin/bash
echo ""
echo "*********** RUN etcd Cluster : Start ************"

ETCD_PATH="{{ dev_dir }}"
infra_name="remote"
infra_ip="{{ ansible_host }}"
listen="http://$infra_ip:2379,http://127.0.0.1:2379"

{{ cluster = "" }}
{% for item in groups['remote'] %}
    cluster"{{ item.ansible_hostname }}=http://{{ item.ansible_host }}:2380"
    {%- if loop.index is not loop.last %}{% continue %}{% endif %}
    	#statements
    fi
{% endfor %}
cluster="infra0=http://$infra1:2380,infra1=http://$infra2:2380,infra2=http://$infra3:2380"


$ETCD_PATH/etcd --name $infra_name --initial-advertise-peer-urls "http://$infra_ip:2380" \
--listen-peer-urls "http://$infra_ip:2380" \
--listen-client-urls $listen \
--advertise-client-urls "http://$infra_ip:2379" \
--initial-cluster-token remote-cluster \
--initial-cluster $cluster \
--initial-cluster-state new
