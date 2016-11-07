## Setup Cluster (on Mac)
1. Set up [Hadoop on Mac](https://amodernstory.com/2014/09/23/installing-hadoop-on-mac-osx-yosemite/): `brew install hadoop` 
2. Install HBase: `brew install hbase`, [set to distributed mode and correct port](https://hbase.apache.org/book.html#quickstart) (9000 if you followed 1.)
3. [Install](http://opentsdb.net/docs/build/html/installation.html) and [configure](http://opentsdb.net/docs/build/html/user_guide/configuration.html) OpenTSDB: `brew install opentsdb` (note: `HBASE_HOME` is the installation folder of HBase on the Master Node, also see [setup wiki page](http://wiki.cvrgrid.org/index.php/OpenTSDB_Cluster_Setup#Installing_OpenTSDB)) 
4. Setup the using the Python script e.g.: `python setup_opentsdb_metrics.py -s stocktickers.csv -m "price,ask,bid"`

