consul_prereq:
  pkg.installed:
    - pkgs:
      - curl
      - unzip

/tmp/install_consul.sh:
  file.managed:
    - source: salt://consul/install_consul.sh
    - mode: '0755'
  cmd.wait:
    - watch:
      - file: /tmp/install_consul.sh

/etc/consul.d:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755

/etc/consul.d/config.json:
  file.managed:
    - source: salt://consul/consul.config
    - template: jinja
    - require:
      - file: /etc/consul.d
    - defaults:
        addr: {{ grains['ip4_interfaces']['eth1'][0] }}

/etc/default/consul:
  file.managed:
    - source: salt://consul/consul.default

/etc/systemd/system/consul.service:
  file.managed:
    - source: salt://consul/consul.service
    - require:
      - cmd: /tmp/install_consul.sh
      - file: /etc/consul.d/config.json
      - file: /etc/default/consul

consul:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/consul.d/config.json
      - cmd: /tmp/install_consul.sh

python-pip:
  pkg.installed

python-consul:
  pip.installed:
    - require:
      - pkg: python-pip
