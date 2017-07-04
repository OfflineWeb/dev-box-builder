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

ETCD_PATH="$1"
infra_name="$2"

infra1="$3"
infra2="$4"
infra3="$5"
if [[ $infra_name == 'infra0' ]]; then 
	infra_ip=$infra1
elif [[ $infra_name == 'infra1' ]]; then
	infra_ip=$infra2
elif [[ $infra_name == 'infra2' ]]; then
	infra_ip=$infra3
fi

cluster="infra0=http://$infra1:2380,infra1=http://$infra2:2380,infra2=http://$infra3:2380"
listen="http://$infra_ip:2379,http://127.0.0.1:2379"

$ETCD_PATH/etcd --name $infra_name --initial-advertise-peer-urls "http://$infra_ip:2380" \
--listen-peer-urls "http://$infra_ip:2380" \
--listen-client-urls $listen \
--advertise-client-urls "http://$infra_ip:2379" \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster $cluster \
--initial-cluster-state new