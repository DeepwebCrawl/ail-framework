#!/bin/bash

# halt on errors
set -e

## bash debug mode togle below
#set -x

if [ -z "$VIRTUAL_ENV" ]; then

    virtualenv -p python3 AILENV

    echo export AIL_HOME=$(pwd) >> ./AILENV/bin/activate
    echo export AIL_BIN=$(pwd)/bin/ >> ./AILENV/bin/activate
    echo export AIL_FLASK=$(pwd)/var/www/ >> ./AILENV/bin/activate
    echo export AIL_REDIS=$(pwd)/redis/src/ >> ./AILENV/bin/activate
    echo export AIL_ARDB=$(pwd)/ardb/src/ >> ./AILENV/bin/activate

fi

if [ ! -z "$TRAVIS" ]; then
    echo "Travis detected"
    ENV_PY="~/virtualenv/python3.6/bin/python"
    export AIL_VENV="~/virtualenv/python3.6/"

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd |sed 's/bin//' )"
    export AIL_HOME="${DIR}"

    export AIL_BIN=${AIL_HOME}/bin/
    export AIL_FLASK=${AIL_HOME}/var/www/
    export AIL_REDIS=${AIL_HOME}/redis/src/
    export AIL_ARDB=${AIL_HOME}/ardb/src/
else
    # activate virtual environment
    . ./AILENV/bin/activate
fi

pip3 install -U pip
pip3 install 'git+https://github.com/D4-project/BGP-Ranking.git/@7e698f87366e6f99b4d0d11852737db28e3ddc62#egg=pybgpranking&subdirectory=client'
pip3 install -U -r requirements.txt

# Pyfaup
pushd faup/src/lib/bindings/python/
python3 setup.py install
popd

# Py tlsh
pushd tlsh/py_ext
python3 setup.py build
python3 setup.py install

# Download the necessary NLTK corpora and sentiment vader
HOME=$(pwd) python3 -m textblob.download_corpora
python3 -m nltk.downloader vader_lexicon
python3 -m nltk.downloader punkt
popd

pushd ${AIL_FLASK}
./update_thirdparty.sh
popd
