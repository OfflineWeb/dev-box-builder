#!/bin/bash

#############################################################################
# The MIT License (MIT)                                                     #
#                                                                           #
# Copyright 2017 papa.                                                      #
#                                                                           #
# Permission is hereby granted, free of charge, to any person obtaining     #
# a copy of this software and associated documentation files  to deal       #
# (the “Software”), in the Software without restriction, including          #
# without limitation the rights to use, copy, modify, merge, publish,       #
# distribute, sublicense, and/or sell copies of the Software, and to permit #
# persons to whom the Software is furnished to do so, subject to the        #
# following conditions:                                                     #
#                                                                           #
# The above copyright notice and this permission notice shall be included   #
# in all copies or substantial portions of the Software.                    #
#                                                                           #
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS   #
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF                #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.    #
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR          #
# ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  #
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE         #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                    #
#############################################################################


echo ""
echo "*********** RUN etcd Cluster : Start ************"

ETCD_PATH="$1" 			# ETCD bin path
cluster_token="$2"		# cluster token
infra_ip="$3"			# IP of this node
shift 3					# move 3 spaces
cluster_ips="$*"		# IPs of all nodes

# create the cluster URL
infra_name=""			# name of this node <infra_node_name>
cluster=""				# cluster URL
cluster_cnt=0			# cluster node number

# the cluster string is like : 
# "<infra_node_name>=http://<infra_node_ip>:2380,<infra_other_node_name>=http://<infra_other_node_ip>:2380"
# this pattern repeats for as many nodes are there
# all nodes have exactly same cluster string
for ip in $cluster_ips; do
	if [[ "$ip" == "$infra_ip" ]]; then
		infra_name="infra$cluster_cnt"
	fi
	cluster+="infra$cluster_cnt=http://$ip:2380,"
	cluster_cnt=$((cluster_cnt + 1))
done

cluster=${cluster:0:-1} # remove trailing comma(,)
echo "etcd cluster : $cluster"

# this node listens on this URL
listen="http://$infra_ip:2379,http://127.0.0.1:2379"

# start the cluster
$ETCD_PATH/etcd --name "$infra_name" \
--initial-advertise-peer-urls "http://$infra_ip:2380" \
--listen-peer-urls "http://$infra_ip:2380" \
--listen-client-urls "$listen" \
--advertise-client-urls "http://$infra_ip:2379" \
--initial-cluster-token "$cluster_token" \
--initial-cluster "$cluster" \
--initial-cluster-state new

echo ""
echo "*********** RUN etcd Cluster : Finish ************"