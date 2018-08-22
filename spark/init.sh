#!/bin/bash

pushd /root > /dev/null

if [ -d "spark" ]; then
  echo "Spark seems to be installed. Exiting."
  return
fi

# Github tag:
if [[ "$SPARK_VERSION" == *\|* ]]
then
  mkdir spark
  pushd spark > /dev/null
  git init
  repo=`python -c "print '$SPARK_VERSION'.split('|')[0]"` 
  git_hash=`python -c "print '$SPARK_VERSION'.split('|')[1]"`
  git remote add origin $repo
  git fetch origin
  git checkout $git_hash
  sbt/sbt clean assembly
  sbt/sbt publish-local
  popd > /dev/null

# Pre-packaged spark version:
else 
  case "$SPARK_VERSION" in
    0.7.3)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.7.3-prebuilt-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.7.3-prebuilt-cdh4.tgz
      fi
      ;;    
    0.8.0)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.8.0-incubating-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.8.0-incubating-bin-cdh4.tgz
      fi
      ;;    
    0.8.1)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.8.1-incubating-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.8.1-incubating-bin-cdh4.tgz
      fi
      ;;    
    0.9.0)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.9.0-incubating-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.9.0-incubating-bin-cdh4.tgz
      fi
      ;;
    0.9.1)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.9.1-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.9.1-bin-cdh4.tgz
      fi
      ;;
    0.9.2)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.9.2-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-0.9.2-bin-cdh4.tgz
      fi
      ;;
    1.0.0)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.0.0-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.0.0-bin-cdh4.tgz
      fi
      ;;
    1.0.1)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.0.1-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.0.1-bin-cdh4.tgz
      fi
      ;;
    1.0.2)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.0.2-bin-hadoop1.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.0.2-bin-cdh4.tgz
      fi
      ;;
    1.1.0)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.1.0-bin-hadoop1.tgz
      elif [[ "$HADOOP_MAJOR_VERSION" == "2" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.1.0-bin-cdh4.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.1.0-bin-hadoop2.4.tgz
      fi
      ;;
    1.1.1)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.1.1-bin-hadoop1.tgz
      elif [[ "$HADOOP_MAJOR_VERSION" == "2" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.1.1-bin-cdh4.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.1.1-bin-hadoop2.4.tgz
      fi
      ;;
    1.2.0)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.0-bin-hadoop1.tgz
      elif [[ "$HADOOP_MAJOR_VERSION" == "2" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.0-bin-cdh4.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.0-bin-hadoop2.4.tgz
      fi
      ;;
    1.2.1)
      rm -f spark-*.tgz
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.1-bin-hadoop1.tgz
      elif [[ "$HADOOP_MAJOR_VERSION" == "2" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.1-bin-cdh4.tgz
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-1.2.1-bin-hadoop2.4.tgz
      fi
      ;;
    *)
      if [[ "$HADOOP_MAJOR_VERSION" == "1" ]]; then
        wget http://s3.amazonaws.com/spark-related-packages/spark-$SPARK_VERSION-bin-hadoop1.tgz
      elif [[ "$HADOOP_MAJOR_VERSION" == "2"  ]] ; then
        if [[ ! -e "spark-$SPARK_VERSION-bin-2.6.0-cdh5.4.2.tgz" ]]; then 
          rm -f spark-*.tgz
          wget https://s3-us-west-2.amazonaws.com/uberdata-public/spark/spark-$SPARK_VERSION-bin-2.6.0-cdh5.4.2.tgz
        fi
        wget -O hive-schema-mysql.sql https://s3-us-west-2.amazonaws.com/uberdata-public/hive/scripts/mysql/hive-schema-0.13.0.mysql.sql
      elif [[ "$HADOOP_MAJOR_VERSION" == "yarn"  ]] ; then
        if [[ ! -e "spark-$SPARK_VERSION-bin-2.6.0-cdh5.4.2.tgz" ]]; then
          rm -f spark-*.tgz
          wget https://s3-us-west-2.amazonaws.com/uberdata-public/spark/spark-$SPARK_VERSION-bin-2.6.0-cdh5.4.2.tgz
        fi
        wget -O hive-schema-mysql.sql https://s3-us-west-2.amazonaws.com/uberdata-public/hive/scripts/mysql/hive-schema-0.13.0.mysql.sql
      else
        wget http://s3.amazonaws.com/spark-related-packages/spark-$SPARK_VERSION-bin-hadoop2.4.tgz
      fi
      if [ $? != 0 ]; then
        echo "ERROR: Unknown Spark version"
        return -1
      fi
  esac

  echo "Unpacking Spark"
  tar xvzf spark-*.tgz > /tmp/spark-ec2_spark.log
  tar xvzf spark-*.tgz -C /home/ec2-user
  ln -s /home/ec2-user/spark-2.1.2-bin-uberdata/ /home/ec2-user/spark
  rm -f spark-*.tgz
  mv `ls -d spark-* | grep -v ec2` spark
  echo "Setting up hive metastore"
  # install mysql jdbc driver in spark/lib
  if [[ ! -e "mysql-connector-java-5.1.34.tar.gz" ]]; then
    wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.34.tar.gz
  fi
  tar -xzvf mysql-connector-java-5.1.34.tar.gz mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar
  #install mysql server connector
  echo "mysql"
  cp mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar  spark/lib
  mkdir /home/ec2-user/jars
  cp mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar /home/ec2-user/jars
  echo "mnt spark folders"
  mkdir /mnt/spark
  mkdir -p /mnt2/spark
  chown -R ec2-user:ec2-user /mnt/spark
  chown -R ec2-user:ec2-user /mnt2/spark

  sed -i "\$i $('echo "PATH=$PATH:/home/ec2-user/spark/bin:/home/ec2-user/mysql-connector-java-5.1.34"')" /home/ec2-user/.bash_profile
  echo "spark root"
  ln -s /root/spark /opt/spark
  cp /root/spark-ec2/ec2-variables.sh /home/ec2-user/
  chown -R  ec2-user:ec2-user /home/ec2-user/
fi

popd > /dev/null
