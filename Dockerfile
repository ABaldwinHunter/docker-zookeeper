FROM elevy/java:7

ENV ZK_VERSION 3.4.6

RUN mkdir -p /zookeeper/data /zookeeper/wal /zookeeper/log && \
    cd /tmp && \
    curl -sSLO http://mirrors.ibiblio.org/apache/zookeeper/stable/zookeeper-${ZK_VERSION}.tar.gz && \
    curl -sSLO http://www.apache.org/dist/zookeeper/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz.asc && \
    curl -sSL https://dist.apache.org/repos/dist/release/zookeeper/KEYS | gpg -q --import - && \
    gpg -q --verify zookeeper-${ZK_VERSION}.tar.gz.asc && \
    tar -zx -C /zookeeper --strip-components=1 -f zookeeper-${ZK_VERSION}.tar.gz && \
    rm -f zookeeper-* && \
    cd /zookeeper && \
    rm -Rf contrib/fatjar dist-maven docs src

COPY zoo.cfg /zookeeper/conf/
COPY log4j.properties /zookeeper/conf/
COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

ENV PATH=/zookeeper/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    ZOO_LOG_DIR=/zookeeper/log \
    ZOO_LOG4J_PROP="INFO, CONSOLE, ROLLINGFILE"

CMD [ "zkServer.sh", "start-foreground" ]

EXPOSE 2181 2888 3888
