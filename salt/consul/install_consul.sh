#!/bin/bash
curl -L https://releases.hashicorp.com/consul/0.7.5/consul_0.7.5_linux_amd64.zip -o /tmp/consul_0.7.5_linux_amd64.zip
unzip -d /usr/local/bin/ /tmp/consul_0.7.5_linux_amd64.zip
chmod a+x /usr/local/bin/consul
