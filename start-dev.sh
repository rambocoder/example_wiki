#!/bin/sh
cd `dirname $0`
exec erl -pa $PWD/ebin \
     -pa /home/alex/Downloads/ChicagoBoss/ebin \
     -pa /home/alex/Downloads/ChicagoBoss/deps/*/ebin \
     -boss developing_app example_wiki \
     -boot start_sasl -config boss -s reloader -s boss \
     -sname wildbill
