# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node for running Jenkins Job Builder jobs.
FROM java:8
MAINTAINER Joost van der Griendt <joostvdg@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get clean
RUN apt-get update -y --fix-missing
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

RUN echo "Installing GIT client"
RUN apt-get -y install git curl bzip2

RUN echo "Installing GIT client and python related tools"
RUN apt-get install -y \
  python-setuptools \
  python-dev \
  libyaml-dev

RUN easy_install pip ordereddict
RUN pip install PyYAML python-jenkins

WORKDIR /home/jenkins
RUN echo "Retrieving jenkins-job-builder sources"
RUN git clone https://github.com/abnamrocoesd/jenkins-job-builder.git
WORKDIR /home/jenkins/jenkins-job-builder

RUN echo "Installing jenkins-job-builder"
RUN python setup.py install

WORKDIR /home/jenkins
COPY jjb-config.ini /home/jenkins

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
