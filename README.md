# probebuild

This network probe build framework provides the following tools:

* Cacti (as a container)
* Smokeping (as a container)
* iperf 2 (as a service)
* iperf 3 (as a service)
* ntopng (as a container)
* tshark
* Portainer.io (for management of Docker Containers)

All data files for the containers are stored in */docker*.

### Getting started

Begin with a fresh Ubuntu Server 20.04 LTS installation..

Start with installing git:
```sh
$ yum install -y git
```
Next, clone the probebuild repo locally and run *./build.sh*:
```sh
$ git clone https://github.com/mcnc-clovett/probebuild-ubuntu.git
$ cd probebuild-ubuntu
$ ./build.sh
```

### Management

You can access most of the web-based services at *http://<probeip>*. However, the following are direct ports for each service.

| Service | Port |
| ------ | ------ |
| Portainer.io | 9000 |
| Cacti | 8080, 443 |
| Smokeping | 8081 |
| iperf | 5001 |
| iperf3 | 5201 |
| ntopng | 3000, 3001 |

All logins are admin/admin by default.
