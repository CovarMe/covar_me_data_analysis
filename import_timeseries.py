#!/usr/bin/python

import sys, getopt, csv, requests, json, time, datetime

def main(argv):
    try:
        opts, args = getopt.getopt(argv,"hH:p:i:s:m:c:t:n:",["host=","port=","interval=","stocks=","metrics=","cols=","timestamp-col==","name-col"])

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

    mapping = zip(metrics.split(","),cols.split(","))
    print 'Uploading Data for ' + metrics + ' on OpenTSDB from csv columns ' + cols

    query_template = {
        "tags": {
            "host": 1
        }
    }
    request_url = host + ":" + str(port) + "/api/put?summary=true&sync=true&details=true"
    with open(source) as s:
        request_data = []
        for i, row in enumerate(csv.DictReader(s)):
            row_query_template = query_template.copy()
            date = datetime.datetime.strptime(row[time_col], "%d/%m/%Y")
            row_query_template['timestamp'] = date.strftime('%s')
            for m, c in mapping:
                q = row_query_template.copy()
                q['metric'] = row[name_col] + '.' + m
                q['value'] =  row[c]
                request_data.append(q)
            
            if i % interval == 0:
                response = requests.post(request_url, data = json.dumps(request_data))
                print response.content
                request_data = []



if __name__ == "__main__":
    main(sys.argv[1:])
