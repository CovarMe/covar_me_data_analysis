## Database Setup
1. Setup the OpenTSDB metrics using the Python script e.g.: `python setup_opentsdb_metrics.py -s stocktickers.csv -m "price,ask,bid"`
2. Import time-series data using _import_timeseries.py_ e.g.: `python import_timeseries.py -H "http://localhost" -p 9001 -i 50 -s stocks.csv -m 'price' -c 'PRC' -t 'date' -n 'TICKER"`

