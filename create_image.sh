#!/bin/bash
# Creates an AMI for the Spark EC2 scripts starting with a stock Amazon
# Linux AMI.
# This has only been tested with Amazon Linux AMI 2014.03.2

set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Dev tools
sudo yum install -y java-1.8.0-openjdk-devel gcc gcc-c++ ant git
# Perf tools
sudo yum install -y dstat iotop strace sysstat htop perf
sudo debuginfo-install -q -y glibc
sudo debuginfo-install -q -y kernel
sudo yum --enablerepo='*-debug*' install -q -y java-1.8.0-openjdk-debuginfo.x86_64

# PySpark and MLlib deps
sudo yum install -y  python-matplotlib python-tornado scipy libgfortran
# Install Epel
sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel-release-latest-7.noarch.rpm
sudo rm -rf epel-release-latest-7.noarch.rpm
# SparkR deps
sudo yum install -y R
# Other handy tools
sudo yum install -y pssh
# Ganglia
sudo yum install -y ganglia ganglia-web ganglia-gmond ganglia-gmetad

# Root ssh config
sudo sed -i 's/PermitRootLogin.*/PermitRootLogin without-password/g' \
  /etc/ssh/sshd_config
sudo sed -i 's/disable_root.*/disable_root: 0/g' /etc/cloud/cloud.cfg

# Set up ephemeral mounts
sudo sed -i 's/mounts.*//g' /etc/cloud/cloud.cfg
sudo sed -i 's/.*ephemeral.*//g' /etc/cloud/cloud.cfg
sudo sed -i 's/.*swap.*//g' /etc/cloud/cloud.cfg

echo "mounts:" >> /etc/cloud/cloud.cfg
echo " - [ ephemeral0, /mnt, auto, \"defaults,noatime,nodiratime\", "\
  "\"0\", \"0\" ]" >> /etc/cloud.cloud.cfg

for x in {1..23}; do
  echo " - [ ephemeral$x, /mnt$((x + 1)), auto, "\
    "\"defaults,noatime,nodiratime\", \"0\", \"0\" ]" >> /etc/cloud/cloud.cfg
done

# Install Maven (for Hadoop)
cd /tmp
wget "http://archive.apache.org/dist/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz"
tar xvzf apache-maven-3.2.3-bin.tar.gz
cp -r apache-maven-3.2.3 /opt/
rm -rf apache-maven-3.2.3

# Edit bash profile
echo "export PS1=\"\\u@\\h \\W]\\$ \"" >> ~/.bash_profile
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0" >> ~/.bash_profile
echo "export M2_HOME=/opt/apache-maven-3.2.3" >> ~/.bash_profile
echo "export PATH=\$PATH:\$M2_HOME/bin" >> ~/.bash_profile

source ~/.bash_profile
# Build Hadoop to install native libs
sudo mkdir /root/hadoop-native
cd /tmp
sudo yum install -y protobuf-compiler cmake openssl-devel
wget "http://archive.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0-src.tar.gz"
tar xvzf hadoop-2.6.0-src.tar.gz
cd hadoop-2.6.0-src
mvn package -Pdist,native -DskipTests -Dtar -Dmaven.javadoc.skip=true
sudo mv hadoop-dist/target/hadoop-2.6.0/lib/native/* /root/hadoop-native
cd ..
rm -f hadoop-2.6.0-src.tar.gz
rm -rf hadoop-2.6.0-src
rm apache-maven-3.2.3-bin.tar.gz

# Install Snappy lib (for Hadoop)
yum install -y snappy
ln -sf /usr/lib64/libsnappy.so.1 /root/hadoop-native/.

# Create /usr/bin/realpath which is used by R to find Java installations
# NOTE: /usr/bin/realpath is missing in CentOS AMIs. See
# http://superuser.com/questions/771104/usr-bin-realpath-not-found-in-centos-6-5
echo '#!/bin/bash' > /usr/bin/realpath
echo 'readlink -e "$@"' >> /usr/bin/realpath
chmod a+x /usr/bin/realpath
mv /root/hadoop-native /root/hadoop-native-2.6

sudo usr/local/bin/pip3 install requests


sudo yum remove -y mariadb-libs
wget https://downloads.mysql.com/archives/get/file/MySQL-5.1.72-1.glibc23.x86_64.rpm-bundle.tar
tar -xvf MySQL-5.1.72-1.glibc23.x86_64.rpm-bundle.tar
sudo yum install -y ./MySQL-*
/sbin/chkconfig mysql off

wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.34.tar.gz
wget https://s3-us-west-2.amazonaws.com/uberdata-public/hadoop/hadoop-2.6.0-cdh5.11.2.tar.gz
wget https://s3-us-west-2.amazonaws.com/uberdata-public/spark/spark-2.1.3-bin-2.6.0-cdh5.11.2.tgz
