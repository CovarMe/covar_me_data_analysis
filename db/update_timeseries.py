# Command Line tool that checks the OpenTSDB database for missing 
# datapoints until today, requests the missing data from yahoo
# finance and adds them to OpenTSDB

import os, sys, getopt, requests, json, time, datetime, logging, csv
from yahoo_finance import Share
from functools import partial
logging.basicConfig(filename='update_timeseries.log',level=logging.DEBUG)


def main(argv):
    # read in command line arguments
    try:
        opts, args = getopt.getopt(argv,"hH:p:b:i:s:f:o:",[
            "host=",
            "port=",
            "batch-size=",
            "interval=",
            "stocks=",
            "from-date=",
            "offset="
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
            print '    -i <call interval seconds (to prevent overloading OpenTSDB)>'
            print '    -s <source file with tickers (csv)>'
            print '    -f date from which to update %Y-%m-%d'
            print '    -o <number of offset rows to start importing from>' 
            sys.exit()
        elif opt in ("-H", "--host"):
            host = arg
        elif opt in ("-p", "--port"):
            port = arg
        elif opt in ("-b", "--batch-size"):
            batch_size = int(arg)
        elif opt in ("-i", "--interval"):
            interval = float(arg)
        elif opt in ("-s", "--source"):
            source = arg
        elif opt in ("-f", "--from-date"):
            from_date = arg
        elif opt in ("-o", "--offset"):
            n_offset = int(arg)
            
    opentsdb_url = "http://" \
            + host + ":" + str(port) \
            + "/api"

    tickers = []
    with open(source) as s:
        csvr = csv.DictReader(s)
        # skip the first n lines according to the offset option
        for i in range(0, n_offset):
            next(csvr)

        for row in csvr :
            print(row['ticker'])
            ticker = row['ticker']
            logging.info(ticker)
            today = time.strftime("%Y-%m-%d")
            try:
                new_stock_data = Share(ticker).get_historical(from_date, today)
                print(new_stock_data)
            except:
                logging.debug("Couldn't retrieve info for " + ticker + " from Yahoo.")
                continue

            # need to add logic here to validate the response
            request_data = []
            for i, day in enumerate(new_stock_data):
                # build an insertion query object
                request_data.append({
                    "metric": day['Symbol'] + ".return",
                    "value": float(day['Close']) / float(day['Open']) - 1,
                    "timestamp": datetime.datetime.strptime(day['Date'], "%Y-%m-%d").strftime('%s'), 
                    "tags": {
                        "company": day['Symbol'],
                    }
                })
                # check if the interval size has been reached and send a request
                if i + 1 == len(new_stock_data) or (i % 50 == 0 and i != 0):
                    response = requests.post(opentsdb_url + '/put?summary=true&details=true', 
                                             data = json.dumps(request_data))
                    print(response)
                    try:
                        response_dict = response.json()
                        logging.info(response_dict['success'])
                        if response_dict['failed'] > 1:
                            logging.debug(response.content)

                    except ValueError:
                        logging.debug(response.content)

                    request_data = []
                    time.sleep(interval)


if __name__ == "__main__":
    main(sys.argv[1:])
