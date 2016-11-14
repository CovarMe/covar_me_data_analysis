## Database Setup
1. Setup the OpenTSDB metrics using the Python script e.g.: `python setup_opentsdb_metrics.py -s stocktickers.csv -m "price,ask,bid"`
2. Import time-series data using _import_timeseries.py_ e.g.: `python import_timeseries.py -H "http://localhost" -p 9001 -i 50 -s stocks.csv -m 'price' -c 'PRC' -t 'date' -n 'TICKER"`
3. Run the `setup_hive_schema.sql` script in the hive shell to create the schemas.
3. Plug the `mongo_schema.py` into the webapp.

## Cluster Setup (Development)
The following is derived from [this tutorial](http://tecadmin.net/setup-hadoop-2-4-single-node-cluster-on-linux/) and done on Davide's server.
```
# check java version 1.8
# add hadoop user (passwd: Distro88)
sudo useradd hadoop
sudo passwd hadoop

# setup ssh for hadoop user
sudo su hadoop
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
exit

# install hadoop
wget http://apache.claz.org/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
tar xzf hadoop-2.7.3.tar.gz
sudo mv hadoop-2.7.3 /home/hadoop/hadoop
sudo cp configs/hadoop/* $HADOOP_HOME/etc/hadoop/
sudo chown -R hadoop:hadoop /home/hadoop

sudo su hadoop
echo "export HADOOP_HOME=/home/hadoop/hadoop" >> ~/.hadoop_env
echo "export HADOOP_INSTALL=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export YARN_HOME=\$HADOOP_HOME" >> ~/.hadoop_env
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> ~/.hadoop_env
echo "export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" >> ~/.hadoop_env
source ~/.hadoop_env
```
