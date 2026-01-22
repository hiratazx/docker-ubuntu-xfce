### Docker image with Ubuntu OS, Xfce desktop & VNC container

### Docker Hub Image
[hiratazx/docker-ubuntu-xfce](https://hub.docker.com/r/hiratazx/docker-ubuntu-xfce/)

Docker image is installed with the following components:
* Ubuntu 24.04 (Noble Numbat)
* Xfce Desktop
* VNC server (TigerVNC, default port: 5901)
* noVNC client (HTML5, default port: 6901)
* OpenSSH
* Java (OpenJDK 8)
* Git, Ant, Vim, Sublime Text
* Mozilla Firefox, Google Chrome

### Usage

**Run command with mapping to local port 5901 (VNC) and 6901 (noVNC):**
```bash
docker run -d -p 5901:5901 -p 6901:6901 hiratazx/docker-ubuntu-xfce
```

**Interactive mode:**
```bash
docker run -it -p 5901:5901 -p 6901:6901 --entrypoint /bin/bash hiratazx/docker-ubuntu-xfce
```

**Override VNC resolution:**
```bash
docker run -d -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=1360x768 hiratazx/docker-ubuntu-xfce
```

**Change VNC password:**
```bash
docker run -d -p 5901:5901 -p 6901:6901 -e VNC_PW=mypassword hiratazx/docker-ubuntu-xfce
```

**Build image from scratch:**
```bash
docker build -t hiratazx/docker-ubuntu-xfce .
```

### Connection ports
* **VNC port:** 5901 - Connect with `[host-ip]:5901`
* **noVNC port:** 6901 - Connect via `http://[host-ip]:6901/?password=[vnc-password]`

### CI/CD
This repository uses GitHub Actions for manual Docker builds and pushes to Docker Hub.
* **Workflow:** `Docker Build and Push`
* **Trigger:** Manual (`workflow_dispatch`)

### Credits
* [Tobias Schneck](https://hub.docker.com/r/consol/ubuntu-xfce-vnc)
* [Jitesh Sojitra](https://hub.docker.com/r/jiteshsojitra/docker-ubuntu-xfce-container)

### Contact
* hiratazx <itzkaguya@yukiprjkt.my.id>