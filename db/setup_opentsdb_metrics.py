#!/usr/bin/python

import subprocess, sys, getopt, csv

def main(argv):
    # read command line arguements
    try:
        opts, args = getopt.getopt(argv,"ht:m:",["tickers=","metrics="])
    except getopt.GetoptError:
        print 'Wrong options supplied, try with -h'
        sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print 'setup_opentsdb_metrics.py -t <csv with stocktickers> -m <desired metrics>'
            sys.exit()
        elif opt in ("-t", "--tickers"):
            tickersfile = arg
        elif opt in ("-m", "--metrics"):
            metrics = arg

    # start creating metrics
    print 'Creating Metrics: ' + metrics + " on OpenTSDB"
    with open(tickersfile) as f:
        call_args = []
        # iterate csv file rows
        for row in csv.reader(f):
            ticker = row[0]
            # create a metric in opentsdb for evey given metric for the company
            for metric in metrics.split(","):
                call_args.append(ticker + "." + metric)  

            # batch create metrics every 500 metrics
            if len(call_args) > 500 * len(metrics):
                subprocess.check_call("tsdb mkmetric " + " ".join(call_args), shell = True)
                call_args = []



if __name__ == "__main__":
    main(sys.argv[1:])
