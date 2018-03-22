***Docker Setup (w/Centos7)***

Install docker:

`yum install docker -y`

Enable and start the docker service:

`systemctl start docker && systemctl enable docker`

(Optional to keep SELinux enabled) Install selinux-dockersock:

```
yum install policycoreutils policycoreutils-python checkpolicy git -y
git clone https://github.com/dpw/selinux-dockersock
cd selinux-dockersock
make
semodule -i dockersock.pp
```

Or disable SELinux...

Pull the required images for the stack.

`docker pull gogs/gogs && docker pull jenkins/jenkins:lts && docker pull docker.bintray.io/jfrog/artifactory-oss:5.9.1 && docker pull postgres && docker pull ppodgorsek/docker-robot-framework`

Add the `docker-compose.yml` file to the working directory.

```
version: "3"

...
```

**Build images**

Build the docker image for Jenkins to add docker support.

`docker build -t jenkins-docker ./dockerfiles/jenkins-docker`

Make directories for volume mounts.

`mkdir -p /srv/gogs /srv/jenkins /srv/artifactory/{data,logs,backup} /srv/postgres`

`chown -R 1000:1000 /srv/jenkins`

Enter a password for PostgreSQL server root.

`export POSTGRESQL_PASSWORD=<password_here>`

We're not actually creating a swarm, but the swarm initialization is needed to use the docker stack feature, and this is a clean way of deploying these services. 

`docker swarm init`

Make attachable network for stack/containers.

`docker network create --driver=overlay --attachable dev`

TODO:
Build robot framework image***
Add Jenkins back to stack***

Deploy stack and launch jenkins container.

`docker stack deploy -c docker-compose.yml <STACK_NAME>`

```
docker run \
--name jenkins \
--network dev \
--privileged \
--restart unless-stopped \
-p 8080:8080 \
-p 50000:50000 \
-v /srv/jenkins:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
jenkins-docker
```

Docker output formatting for `docker ps` (Optional but helpful):

`export FORMAT="\nID\t{{.ID}}\nIMAGE\t{{.Image}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.RunningFor}}\nSTATUS\t{{.Status}}\nPORTS\t{{.Ports}}\nNAMES\t{{.Names}}\n"`

Service/container status commands:

```
docker ps --format $FORMAT --no-trunc
docker stack ps <STACK_NAME> --no-trunc
docker stack services <STACK_NAME> 
```

Example - inspect running container volumes:

`docker ps | awk 'FNR > 1 {print $NF}' | xargs docker inspect -f '{{index .Config.Labels "com.docker.swarm.service.name"}}{{.Mounts}}' | sed 's/\[{/\n\[{\n/g;s/ \//\n\//g;s/ local/\nlocal/g;s/{vol/\n{\nvol/g;s/}]/\n}]\n/g;s/ }/\n}/g'`

**Gogs Setup**

Configure Postgresql for GOGS:

`docker exec -ti <POSTGRES_CONTAINER> su - postgres -c "createuser -P gogs; createdb -O gogs gogs"`

Add Gogs webhook for Jenkins with a Gogs secret.

`http://jenkins:8080/gogs-webhook/?job=testWeb`

Provide password for gogs db user.

**Jenkins Setup**

Plugins to install: Artifactory, Gogs, Robot Framework, Go(Golang), Node(NodeJS, NPM Pipeline Integration)

Set docker binary path.

Create pipeline job using jenkinsfile. Select the settings: Use Gogs secret, Build when a change is pushed to Gogs.

```
node {
        // Install the desired Go version
        def root = tool name: 'go-1.9.3', type: 'go'
        
        ...

        
    }
```

**Artifactory Setup**

Create generic repo to hold binaries and tarfiles. 

Create docker registry for docker images. 

TODO: limit number of previous versions.