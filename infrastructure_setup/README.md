## Cluster Setup (Development)
The following is derived from [this tutorial](http://tecadmin.net/setup-hadoop-2-4-single-node-cluster-on-linux/) and done on Davide's server.
1. Install Java Version 8 first if necessary
```
# create environment variables file
echo "export HADOOP_HOME=$(pwd)/hadoop-2.7.3" >> ~/.hadoop_env
echo "export HADOOP_INSTALL=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export YARN_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> ~/.hadoop_env
echo "export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" >> ~/.hadoop_env
source ~/.hadoop_env

# install hadoop
wget http://apache.claz.org/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
tar xzf hadoop-2.7.3.tar.gz
cp covar_me_data_analysis/infrastructure_setup/configs/hadoop/* hadoop-2.7.3/etc/hadoop
hadoop-2.7.3/bin/hdfs namenode -format
hadoop-2.7.3/sbin/start-dfs.sh
hadoop-2.7.3/sbin/start-yarn.sh

# install hbase
wget http://apache.uvigo.es/hbase/stable/hbase-1.2.4-bin.tar.gz
tar zxf hbase-1.2.4-bin.tar.gz
hbase-1.2.4/bin/start-hbase.sh

# install opentsdb
wget https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.1/opentsdb-2.2.1.tar.gz
tar zxf opentsdb-2.2.1.tar.gz
cd opentsdb-2.1.1
./build.sh
env COMPRESSION=NONE HBASE_HOME=path/to/hbase ./src/create_table.sh
```
