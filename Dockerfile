############################################################
# Inspired by "Tobias Schneck" for Dockerfile creation from https://hub.docker.com/r/consol/ubuntu-xfce-vnc.
#
# Dockerfile: https://hub.docker.com/r/jiteshsojitra/docker-ubuntu-xfce-container
# This docker file is used to build an vnc image based on Ubuntu OS & Xfce UI.
# Connection ports for controlling the UI:
# VNC port: 5901, connect with <host-ip> and 5901 port
# noVNC port: 6901, connect via http://<host-ip>:6901/?password=<vnc-password>
############################################################

FROM ubuntu:24.04
LABEL maintainer="hiratazx <itzkaguya@yukiprjkt.my.id>"

# Environment variables
ENV REFRESHED_AT=2026-01-22
ENV HOME=/home/itzkaguya \
	SCRIPTS_DIR=/home/itzkaguya/scripts \
	NO_VNC_DIR=/home/itzkaguya/noVNC \
	DISPLAY=:1 \
	TERM=xterm \
	VNC_PORT=5901 \
	NO_VNC_PORT=6901 \
	VNC_COL_DEPTH=24 \
	VNC_RESOLUTION=1360x768 \
	VNC_PW=test123 \
	VNC_VIEW_ONLY=false \
	DEBIAN_FRONTEND=noninteractive \
	LANG='en_US.UTF-8' LANGUAGE='en_US:en'

# Working directory
WORKDIR $HOME

# Expose ports
EXPOSE $VNC_PORT $NO_VNC_PORT

# Create scripts dir and user
RUN mkdir -p $SCRIPTS_DIR && \
    useradd -m -s /bin/bash -u 1000 itzkaguya && \
    echo "itzkaguya ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install OS packages (Cache this layer)
COPY --chown=itzkaguya:itzkaguya ./src/scripts/packages.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/packages.sh && $SCRIPTS_DIR/packages.sh

# Install required softwares (Cache this layer)
COPY --chown=itzkaguya:itzkaguya ./src/scripts/core.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/core.sh && $SCRIPTS_DIR/core.sh

# Add XFCE config (Cache this layer)
ADD --chown=itzkaguya:itzkaguya ./src/xfce $HOME

# Install required utilities
COPY --chown=itzkaguya:itzkaguya ./src/scripts/utils.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/utils.sh && $SCRIPTS_DIR/utils.sh

# Post configurations
COPY --chown=itzkaguya:itzkaguya ./src/scripts/post-configs.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/post-configs.sh && $SCRIPTS_DIR/post-configs.sh

# Set permissions
COPY --chown=itzkaguya:itzkaguya ./src/scripts/set-permissions.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/set-permissions.sh && $SCRIPTS_DIR/set-permissions.sh $SCRIPTS_DIR $HOME

# Copy startup scripts (Last layer, most frequent changes)
COPY --chown=itzkaguya:itzkaguya ./src/scripts/vnc-startup.sh ./src/scripts/generate-container-user.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/vnc-startup.sh $SCRIPTS_DIR/generate-container-user.sh

# Switch to user
USER itzkaguya

# Entrypoint
ENTRYPOINT ["/home/itzkaguya/scripts/vnc-startup.sh"]
CMD ["--tail-log"]
