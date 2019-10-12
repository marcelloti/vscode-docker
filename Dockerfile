FROM debian:buster-slim

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install libcanberra-gtk-module libgconf-2-4 libasound2 libgtk2.0-0 libxss1 sudo curl wget libx11-xcb-dev && \ 
    apt-get -y -f install
    
RUN adduser --disabled-password --gecos "" developer && mkdir /home/developer/code && chmod 777 -R /home/developer/code
    
# Install Visual Studio Code
RUN curl -L 'https://go.microsoft.com/fwlink/?LinkID=760868' -o "/tmp/vscode.deb"
RUN dpkg -i "/tmp/vscode.deb"; exit 0;
RUN apt-get -y -f install

RUN echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer
   
ADD ./init.sh /usr/local/bin/init.sh

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install -y nodejs

USER developer
ENV HOME /home/developer

# Update fonts cache
RUN fc-cache -f -v

ENTRYPOINT /usr/local/bin/init.sh && /bin/bash
