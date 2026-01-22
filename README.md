### Docker image with Ubuntu OS, Xfce desktop & VNC container

### Docker Hub Image:
https://hub.docker.com/r/hiratazx/docker-ubuntu-xfce/

Docker image is installed with the following components:
* UBUNTU 24.04 (Noble Numbat)
* Xfce desktop
* VNC server (default VNC port: 5901)
* VNC client with html5 support (default http port: 6901)
* OpenSSH
* Java (OpenJDK 8)
* Git
* Ant
* Vim
* Mozilla Firefox
* Google Chrome
* Sublime Editor

### Usage:
Run command with mapping to local port 5901 (vnc protocol) and 6901 (vnc web access):
- `docker run -d -p 5901:5901 -p 6901:6901 hiratazx/docker-ubuntu-xfce`

If you want to get into the container use interactive mode:
- `docker run -it -p 5901:5901 -p 6901:6901 --entrypoint /bin/bash hiratazx/docker-ubuntu-xfce`

If you want to override the VNC resolution:
- `docker run -d -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=1360x768 hiratazx/docker-ubuntu-xfce`

If you want to change the VNC password:
- `docker run -d -p 5901:5901 -p 6901:6901 -e VNC_PW=[vnc-password] hiratazx/docker-ubuntu-xfce`

Build an image from scratch:
- `docker build -t hiratazx/docker-ubuntu-xfce .`

### CI/CD
This repository is equipped with a GitHub Actions workflow that allows for manual triggering of Docker builds and pushes to Docker Hub.
- **Workflow**: `Docker Build and Push`
- **Trigger**: Manual (`workflow_dispatch`)

### Connection ports for controlling the UI:
- VNC port: 5901, connect with `[host-ip]:5901`
- noVNC port: 6901, connect via `http://[host-ip]:6901/?password=[vnc-password]`

### Note:
- There are some settings in docker container which are required for building Zimbra Selenium (https://github.com/Zimbra/zm-selenium).

### Credits:
- Tobias Schneck (https://hub.docker.com/r/consol/ubuntu-xfce-vnc)
- Jitesh Sojitra (https://hub.docker.com/r/jiteshsojitra/docker-ubuntu-xfce-container)

### Contact:
- hiratazx <itzkaguya@yukiprjkt.my.id>