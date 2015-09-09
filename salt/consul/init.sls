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

/etc/consul:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755

/etc/consul/config.json:
  file.managed:
    - source: salt://consul/consul.config
    - require:
      - file: /etc/consul

/etc/init/consul.conf:
  file.managed:
    - source: salt://consul/consul.service
    - require:
      - cmd: /tmp/install_consul.sh
      - file: /etc/consul/config.json

consul:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/consul/config.json
      - cmd: /tmp/install_consul.sh

python-pip:
  pkg.installed

python-consul:
  pip.installed:
    - require:
      - pkg: python-pip
