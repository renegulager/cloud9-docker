# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# And https://github.com/kdelfour/cloud9-docker
# ------------------------------------------------------------------------------
# Pull base image.
FROM ubuntu
MAINTAINER René Gulager Larsen <mail@renegulager.dk

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs python2.7


# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

    
# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /c9
WORKDIR /c9
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /c9/configs/standalone.js 

# Add supervisord conf
ADD conf/c9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Install and config supervisor 
RUN \
  apt-get update && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
#RUN apt-get install -y supervisor 
#RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

VOLUME ["/etc/supervisor/conf.d"]
RUN update-rc.d supervisor defaults
RUN apt-get update | apt-get upgrade -y
RUN apt-get install libpam-cracklib -y
RUN ln -s /lib/x86_64-linux-gnu/security/pam_cracklib.so /lib/security
WORKDIR /etc/supervisor/conf.d
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]


# ------------------------------------------------------------------------------
# upgrade
RUN apt-get upgrade -y

# ------------------------------------------------------------------------------
# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000

# ------------------------------------------------------------------------------
