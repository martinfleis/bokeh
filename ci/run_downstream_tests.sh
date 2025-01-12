#!/bin/bash

banner() {
  echo
  echo "+------------------------------------------------------------------------------------+"
  printf "| %-80s   |\n" "$@"
  echo "+------------------------------------------------------------------------------------+"
  echo
}

banner_and_restore() {
        banner "$*"
        case "$save_flags" in
         (*x*)  set -x
        esac
}

alias banner='{ save_flags="$-"; set +x;} 2> /dev/null; banner_and_restore'

set -x #echo on

set +e

pushd "$(python -c 'import site; print(site.getsitepackages()[0])')" || exit

banner "Dask -- dask/diagnostics" 2> /dev/null
pytest dask/diagnostics

banner "Dask -- distributed/dashboard" 2> /dev/null
pytest distributed/dashboard

banner "Panel" 2> /dev/null
pytest panel/tests

banner "Holoviews" 2> /dev/null
nosetests holoviews/tests/plotting/bokeh

popd || exit

banner "PandasBokeh" 2> /dev/null
pytest Pandas-Bokeh/Tests/test_PandasBokeh.py

banner "GeoPandasBokeh" 2> /dev/null
pytest Pandas-Bokeh/Tests/test_GeoPandasBokeh.py

exit 0
