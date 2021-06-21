FROM ubuntu:18.04
WORKDIR /project
RUN apt-get update -y && \
    apt-get install nano wget git sudo curl -y
ADD . /project/
RUN cd /project && \
    ./installing_deps.sh
CMD bash /project/bin/LAUNCH.sh -l