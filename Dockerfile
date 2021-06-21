FROM ubuntu:18.04
WORKDIR /project
RUN sudo apt-get update && \
    sudo apt-get install nano wget git sudo curl -y
RUN echo "Asia/Ho_Chi_Minh" > /etc/timezone
ADD . /project/
RUN cd /project && \
    ./installing_deps.sh
RUN cd /project/var/www/ && \
    bash update_thirdparty.sh
CMD bash /project/bin/LAUNCH.sh -l
