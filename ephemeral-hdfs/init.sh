#!/bin/bash

pushd /root > /dev/null

if [ -d "ephemeral-hdfs" ]; then
  echo "Ephemeral HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://s3.amazonaws.com/spark-related-packages/hadoop-1.0.4.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.0.4/ ephemeral-hdfs/
    sed -i 's/-jvm server/-server/g' /root/ephemeral-hdfs/bin/hadoop
    cp /root/hadoop-native/* /root/ephemeral-hdfs/lib/native/
    ;;
  2)
    if [[ ! -e "hadoop-2.6.0-cdh5.11.2.tar.gz" ]]; then  
      wget https://s3-us-west-2.amazonaws.com/uberdata-public/hadoop/hadoop-2.6.0-cdh5.11.2.tar.gz
    fi
    echo "Unpacking Hadoop"
    tar xvzf hadoop-2.6.0-cdh5.11.2.tar.gz > /tmp/spark-ec2_hadoop.log
    rm -f hadoop-*.tar.gz
    mv hadoop-2.6.0-cdh5.11.2/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf /root/ephemeral-hdfs/etc/hadoop/
    ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
    cp /root/hadoop-native-2.6/* ephemeral-hdfs/lib/native/
    ;;
  yarn)
    wget https://s3-us-west-2.amazonaws.com/uberdata-public/hadoop/hadoop-2.6.0.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-2.6.0.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.6.0/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf /root/ephemeral-hdfs/etc/hadoop/
    ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return 1
esac
/root/spark-ec2/copy-dir /root/ephemeral-hdfs

popd > /dev/null
