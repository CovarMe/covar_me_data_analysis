import sys, getopt, requests, json, time, datetime, logging
from yahoo_finance import Share
from multiprocessing import Pool
logging.basicConfig(filename='update_timeseries.log',level=logging.DEBUG)

opentsdb_url = "http://" \
        + os.environ.get("OPENTSDB_HOST") \
        + ":" + os.environ.get("OPENTSDB_PORT") \
        + "/api/query/last"


def get_data_end_date(ticker, metric):
    request_data = json.dumps({
        "queries": {
            "metric": ticker + '.' + metric,
        }
    })
    response = request.post(opentsdb_url, 
                            data = request_data)
    return response.json()


def update_timeseries(ticker):
    today = time.strftime("%d-%m-%Y")
    last_date = get_data_end_date(ticker, 'return')
    response = yahoo.get_historical(last_date, today)
    # need to add logic here to validate the response
    for i, row in enumerate(dic):
        # build an insertion query object
        request_data.append({
            "metric": row['Symbol'] + ".return",
            "value": row['Close']/row['Open'] - 1,
            "timestamp":datetime.datetime.strptime(row['Date'], "%Y-%m-%d").strftime('%s'), 
            "tags": {
                "company": row['Symbol'],
            }
        })
        # check if the interval size has been reached and send a request
        if i % 50 == 0 and i != 0:
            response = requests.post(request_url, 
                                     data = json.dumps(request_data))
            response_dict = response.json()
            request_data = []


def main(argv):
    # read in command line arguments
    try:
        opts, args = getopt.getopt(argv,"hH:p:b:i:s:",[
            "host=",
            "port=",
            "batch-size=",
            "interval=",
            "stocks=",
        ])
    except getopt.GetoptError:
        print 'Wrong options supplied, try with -h'
        sys.exit(2)
        
    for opt, arg in opts:
        if opt == '-h':
            print 'setup_opentsdb_metrics.py'
            print '    -H <host>'
            print '    -p <port>'
            print '    -b <request batch size>'
            print '    -i <repeat interval for the updating>'
            print '    -s <source file with tickers (csv)>'
            sys.exit()
        elif opt in ("-H", "--host"):
            host = arg
        elif opt in ("-p", "--port"):
            port = arg
        elif opt in ("-b", "--batch-size"):
            batch_size = int(arg)
        elif opt in ("-i", "--interval"):
            interval = int(arg)
        elif opt in ("-s", "--source"):
            source = arg
        # spawn multiple processes to update the timeseries
        with open(source) as s:
            p = Pool(32)
            p.map(update_timeseries, csv.reader(s))
