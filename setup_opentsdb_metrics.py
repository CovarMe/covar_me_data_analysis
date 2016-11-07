#!/usr/bin/python

import subprocess, sys, getopt, csv

def main(argv):
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

    print 'Creating Metrics: ' + metrics + " on OpenTSDB"

    with open(tickersfile) as f:
        metrics = metrics.split(",")
        call_args = []
        for row in csv.reader(f):
            ticker = row[0]
            if len(call_args) > 100 * len(metrics):
                subprocess.check_call("tsdb mkmetric " + " ".join(call_args), shell = True)
                call_args = []

            for metric in metrics.split(","):
                call_args.append(ticker + "." + metric)  




if __name__ == "__main__":
    main(sys.argv[1:])
