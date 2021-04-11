# probebuild

This network probe build framework provides the following tools:

* Cacti (as a container)
* Smokeping (as a container)
* iperf 2 (as a service)
* iperf 3 (as a service)
* ntopng (as a container)
* tshark
* Portainer.io (for management of Docker Containers)
* Cockpit

All data files for the containers are stored in */docker*.

### Getting started

Begin with a fresh Ubuntu Server 20.04 LTS installation..

Clone the probebuild repo locally and run *./build.sh*:
```sh
$ git clone https://github.com/mcnc-clovett/probebuild-ubuntu.git
$ cd probebuild-ubuntu
$ ./build.sh
```
Once the build is done, you'll need to log out and back in. Once you've
logged back in, run:
```sh
$ cd probebuild-ubuntu
$ ./docker-compose up -d
```

### Management

You can access most of the web-based services at *http://<probeip>*. However, the following are direct ports for each service.

| Service | Port |
| ------ | ------ |
| Portainer.io | https/9000 |
| Cockpit | https/9090 |
| Cacti | 8080, https/443 |
| Smokeping | 8081 |
| iperf | 5001 |
| iperf3 | 5201 |
| ntopng | https/3001 |

All logins are admin/admin by default, except Cockpit which is the linux user's login.
