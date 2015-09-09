#!/bin/bash
curl -L https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip -o /tmp/0.5.2_linux_amd64.zip
unzip -d /usr/local/bin/ /tmp/0.5.2_linux_amd64.zip
chmod a+x /usr/local/bin/consul
curl -L https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip -o /tmp/0.5.2_web_ui.zip
mkdir -p /opt/consul
unzip -d /opt/consul /tmp/0.5.2_web_ui.zip
