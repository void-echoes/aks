FROM openjdk:8-jdk
# Set Spark version
ARG SPARK_VERSION=3.3.2
# Set Hadoop version
ARG HADOOP_VERSION=3
# Set ABFSS connector version
ARG ABFSS_VERSION=12.15.0
# Set Spark home directory
ENV SPARK_HOME=/opt/spark
# Download and install Spark
RUN apt-get update && \
    apt-get install -y wget && \
    wget -q https://downloads.apache.org/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz && \
    tar xf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN chmod 777 /opt/spark/jars
ARG HADOOP_VERSION=3.0.0
# Add ABFSS connector jars to Spark classpath
RUN wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/${HADOOP_VERSION}/hadoop-azure-${HADOOP_VERSION}.jar -P ${SPARK_HOME}/jars && \
    wget -q https://repo1.maven.org/maven2/com/azure/azure-storage-file-datalake/${ABFSS_VERSION}/azure-storage-file-datalake-${ABFSS_VERSION}.jar -P ${SPARK_HOME}/jars
RUN wget -q https://repo1.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.3.6/azure-data-lake-store-sdk-2.3.6.jar  -P ${SPARK_HOME}/jars
RUN wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.3/hadoop-azure-3.3.3.jar  -P ${SPARK_HOME}/jars
RUN wget -q https://repo1.maven.org/maven2/com/azure/azure-identity/1.1.0/azure-identity-1.1.0.jar  -P ${SPARK_HOME}/jars
RUN wget -q https://jdbc.postgresql.org/download/postgresql-42.5.4.jar -P ${SPARK_HOME}/jars
RUN wget -q https://repo1.maven.org/maven2/com/azure/azure-core/1.7.0/azure-core-1.7.0.jar -P ${SPARK_HOME}/jars

# Set Spark configuration
ENV SPARK_CONF_DIR=${SPARK_HOME}/conf
ENV PATH=${PATH}:${SPARK_HOME}/bin
ENV HIVE_BASE_LOC=/eu_uat/hive
# Set Spark log directory

#ENV SPARK_MASTER_PORT=7077 \
#SPARK_MASTER_WEBUI_PORT=8080 \
ENV SPARK_LOG_DIR=/opt/spark/logs
#SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out \
#SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out \
#SPARK_WORKER_WEBUI_PORT=8080 \
#SPARK_WORKER_PORT=7000

# Create Spark log directory
RUN mkdir -p ${SPARK_LOG_DIR}
RUN chmod 777 /opt/spark/bin/spark-class
RUN mkdir -p /metastore_db && chmod -R 777 /metastore_db
RUN mkdir -p /opt/spark/work && chmod -R 777 /opt/spark/work

# Expose Spark ports
EXPOSE 4040 6066 7077 8080
WORKDIR /tmp
WORKDIR /opt/spark/conf
#COPY /config/spark-defaults.conf .
#RUN chmod 777 /opt/spark/bin/spark-class

CMD ${SPARK_HOME}/sbin/start-master.sh -h spark-master