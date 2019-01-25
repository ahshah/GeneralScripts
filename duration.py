#!/usr/bin/env python
import  datetime
import fileinput

def main():
    for line in fileinput.input():
        start = line.split()[0]
        end = line.split()[1]

        hour_included_start = start.count(':') > 1
        hour_included_end = end.count(':') > 1

        if not hour_included_start:
            start = '0:' + start

        if not hour_included_end:
            end = '0:' + end

        date_start = datetime.datetime.strptime(start, '%H:%M:%S');
        date_end = datetime.datetime.strptime(end, '%H:%M:%S');

        td =  date_end - date_start
        print (start + " " + str(td))

if __name__ == "__main__":
    main();
