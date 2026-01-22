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
ENV HOME=/root \
	SCRIPTS_DIR=/root/scripts \
	NO_VNC_DIR=/root/noVNC \
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

# Create scripts dir
RUN mkdir -p $SCRIPTS_DIR

# Install OS packages (Cache this layer)
COPY ./src/scripts/packages.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/packages.sh && $SCRIPTS_DIR/packages.sh

# Install required softwares (Cache this layer)
COPY ./src/scripts/core.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/core.sh && $SCRIPTS_DIR/core.sh

# Add XFCE config (Cache this layer)
ADD ./src/xfce $HOME

# Install required utilities
COPY ./src/scripts/utils.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/utils.sh && $SCRIPTS_DIR/utils.sh

# Post configurations
COPY ./src/scripts/post-configs.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/post-configs.sh && $SCRIPTS_DIR/post-configs.sh

# Set permissions
COPY ./src/scripts/set-permissions.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/set-permissions.sh && $SCRIPTS_DIR/set-permissions.sh $SCRIPTS_DIR $HOME

# Copy startup scripts (Last layer, most frequent changes)
COPY ./src/scripts/vnc-startup.sh ./src/scripts/generate-container-user.sh $SCRIPTS_DIR/
RUN chmod a+x $SCRIPTS_DIR/vnc-startup.sh $SCRIPTS_DIR/generate-container-user.sh

# Entrypoint
ENTRYPOINT ["/root/scripts/vnc-startup.sh"]
CMD ["--tail-log"]
