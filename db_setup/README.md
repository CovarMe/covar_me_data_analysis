## Database Setup
1. Setup the OpenTSDB metrics using the Python script e.g.: `python setup_opentsdb_metrics.py -s stocktickers.csv -m "price,ask,bid"`
2. Import time-series data using _import_timeseries.py_ e.g.: `python import_timeseries.py -H "http://localhost" -p 9001 -i 50 -s stocks.csv -m 'price' -c 'PRC' -t 'date' -n 'TICKER"`
3. Run the `setup_hive_schema.sql` script in the hive shell to create the schemas.
3. Plug the `mongo_schema.py` into the webapp.
