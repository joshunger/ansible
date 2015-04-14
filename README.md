
# External Services Required

GitHub DockerHub, CircleCI

# Dev Project

install rails, git, docker
build the rails app
test building and running it with a Dockerfile
push changes to GitHub

## Add confd


### Ship App

wget https://github.com/kelseyhightower/confd/releases/download/v0.6.3/confd-0.6.3-linux-amd64

sudo mv confd-0.6.3-linux-amd64 /usr/local/bin/confd
sudo chmod +x /usr/local/bin/confd

/etc/confd/conf.d/myconfig.toml

[template]
src = "myconfig.conf.tmpl"
dest = "/tmp/application.conf"
keys = [
    "/myapp/database/url",
    "/myapp/database/user",
]

epxort APPLICATION=bandj
epxort DEPLOY_TYPE=staging
confd -prefix=/$APPLICATION -onetime -backend etcd -node $COREOS_PRIVATE_IPV4:4001





# CircleCI

create a circle.yml file in the project root
add credentials to CircleCI account
configure circle to push to Docker Hub on successful test of code

# Ansible

## Cluster Management

https://ivan-site.com/2014/10/auto-scaling-on-amazon-ec2-with-ansible/


## Application Management

to manage CoreOS with fleetctl requires an external host that has the fleet binary installed
binaries can be found here:  https://github.com/coreos/fleet/releases

See: http://2mohitarora.blogspot.sg/2014/05/manage-docker-containers-using-coreos.html


# CoreOS

## Service files

See: https://coreos.com/docs/launching-containers/launching/getting-started-with-systemd/


/etc/systemd/system/ship.service

```
[Unit]
Description=Ship
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill ship
ExecStartPre=-/usr/bin/docker rm ship
ExecStartPre=/usr/bin/docker pull rjayroach/ship
# Note: Remove the -d flag to docker run when running container from fleetctl
ExecStart=/usr/bin/docker run --name ship -d -p 3000:3000 rjayroach/ship
ExecStartPost=/usr/bin/etcdctl set /apps/ship/staging running
ExecStop=/usr/bin/docker stop ship
ExecStopPost=/usr/bin/etcdctl rm /apps/ship/staging

[Install]
WantedBy=multi-user.target

#Note: Replace the[Install] secition with [X-Fleet]

[X-Fleet]
X-Conflicts=ship@*.service
```


sudo systemctl enable /etc/systemd/system/ship.service


sudo systemctl start ship.service

sudo systemctl daemon-reload

journalctl -f -u ship

docker logs -f ship

## Discovery URL

as per: https://coreos.com/docs/cluster-management/setup/cluster-discovery/

curl -w "\n" https://discovery.etcd.io/new

## Fleet

core@ip-172-31-11-196 / $ cat /run/systemd/system/etcd.service.d/20-cloudinit.conf
[Service]
Environment="ETCD_ADDR=54.169.55.192:4001"
Environment="ETCD_DISCOVERY=https://discovery.etcd.io/18513c6d0434eae1f0d5e5ba693a0fd7"
Environment="ETCD_PEER_ADDR=54.169.55.192:7001"

cat /etc/machine-id

### fleetctl

ssh-add ~/.ssh/test-ansible-keypair.pem
fleetctl list-machines
fleetctl ssh 79ed

fleetctl submit hello.service
fleetctl list-unit-files
fleetctl cat hello.service
fleetctl load hello.service
fleetctl list-unit-files
fleetctl list-units

fleetctl start hello
docker logs -f hello

fleetctl stop hello.service
fleetctl unload hello.service
fleetctl destroy hello.service


### etcdctl

See: https://www.digitalocean.com/community/tutorials/how-to-use-etcdctl-and-etcd-coreos-s-distributed-key-value-store

```etcdctl ls /_etcd/machines --recursive```

etcdctl ls /
etcdctl ls /coreos.com --recursive
etcdctl get /coreos.com/updateengine/rebootlock/semaphore

etcdctl mkdir /example

To make a key, you can use the mk command:

etcdctl mk /example/key data
etcdctl ls /example
etcdctl update /example/key turtles


OR use curl


curl -L http://127.0.0.1:4001/v2/keys/

curl -L http://127.0.0.1:4001/v2/stats/leader
curl -L http://127.0.0.1:4001/v2/stats/self



# Ansible

http://stackoverflow.com/questions/23945201/how-to-run-only-one-task-in-ansible-playbook

# Dynamic Inventory


First, download the ec2.py script and ec2.ini file to your Ansible directory /etc/ansible:
# cd /etc/ansible
# wget https://raw.github.com/ansible/ansible/devel/plugins/inventory/ec2.py
# wget https://raw.github.com/ansible/ansible/devel/plugins/inventory/ec2.ini
# chmod +x ec2.py
