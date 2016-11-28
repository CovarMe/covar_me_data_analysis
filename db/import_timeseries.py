#!/usr/bin/python

import sys, getopt, csv, requests, json, time, datetime, logging
logging.basicConfig(filename='import_timeseries.log',level=logging.DEBUG)

def main(argv):
    # this entire first part is only for reading in the command line arguments 
    try:
        opts, args = getopt.getopt(argv,"hH:p:i:s:m:c:t:n:o:",[
            "host=",
            "port=",
            "interval=",
            "stocks=",
            "metrics=",
            "cols=",
            "timestamp-col=",
            "name-col="
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
            print '    -i <row interval (request size)>'
            print '    -s <source file with data (csv)>'
            print '    -m <desired metrics (seperated by commas)>'
            print '    -c <corresponding columns (in same order)>'
            print '    -t <label of the timestamp column in data>'
            print '    -n <label of the company name column in data (e.g. ticker)>'
            print '    -o <number of offset rows to start importing from>' 
            sys.exit()
        elif opt in ("-H", "--host"):
            host = arg
        elif opt in ("-p", "--port"):
            port = arg
        elif opt in ("-i", "--interval"):
            interval = int(arg)
        elif opt in ("-s", "--source"):
            source = arg
        elif opt in ("-m", "--metrics"):
            metrics = arg
        elif opt in ("-c", "--cols"):
            cols = arg
        elif opt in ("-t", "--timestamp-col"):
            time_col = arg
        elif opt in ("-n", "--name-col"):
            name_col = arg
        elif opt in ("-o", "--offset"):
            n_offset = int(arg)

    # create a mapping from the given metrics that are supposed to be imported
    # to their corresponding columns in the data file
    mapping = zip(metrics.split(","),cols.split(","))
    print 'Uploading Data for ' + metrics + ' on OpenTSDB from csv columns ' + cols

    # define static elements that are the same for ever insert query
    # build the URL to send the database request to
    request_url = host + ":" + str(port) + "/api/put?summary=true&details=true"
    with open(source) as s:
        request_data = []
        inserted = 0
        csvr = csv.DictReader(s)
        # skip the first n lines according to the offset option
        for i in range(0, n_offset):
            next(csvr)

        # iterate through the lines of the given csv
        for i, row in enumerate(csvr):
            # get the correct timestamp from the given date column
            date = datetime.datetime.strptime(row[time_col], "%d/%m/%Y")
            # build a query object
            row_query_template = {
                "timestamp": date.strftime('%s'), 
                "tags": {
                    "company": row[name_col],
                }
            }
            for m, c in mapping:
                # build metrics from the metric, column mappings
                q = row_query_template.copy()
                q['metric'] = row[name_col] + '.' + m
                q['value'] =  row[c]
                q['tags']['metric'] = m
                request_data.append(q)

            # check if the interval size has been reached and send a request
            if i % interval == 0 and i != 0:
                time.sleep(0.25)
                print '='
                response = requests.post(request_url, 
                                         data = json.dumps(request_data))
                try:
                    response_dict = response.json()
                    if response_dict['failed'] > 1:
                        time.sleep(1)
                        logging.debug(response.content)

                    inserted += response_dict['success']
                    logging.debug('Inserted: ' + str(inserted))
                    request_data = []
                except ValueError:
                    time.sleep(1)
                except:
                    sys.exit(response.reason)



if __name__ == "__main__":
    main(sys.argv[1:])
