#!/bin/bash

WALLET="Svkqb6kWsfBFDid9YDLwKzLAQzDgYMHSB5PTDdGf87LQNkc5Ji4wS2ahwqB2o9gx5kSSmxz2FKZhrXsCBvjnKaV22rM1y76hy"
WORKER="NewPhone"
THREADS="$(( $(nproc) - 2 ))"

announce() {
    echo -e "\n--------------------------------\n $1 \n--------------------------------\n"
}

announce    'Updating system...            '                                             &&
sudo        apt-get                                              update                  &&
announce    'Beginning system upgrade...   '                                             &&
sudo        apt-get                                              upgrade    -y           &&
announce    'Installing dependencies...    '                                             &&
sudo        apt-get install screen nano git build-essential \
                cmake libuv1-dev libssl-dev libhwloc-dev         -y                      &&
announce    'Moving to src directory...    '                                             &&
cd          /usr/src                                                                     &&
announce    'Changing permissions...       '                                             &&
sudo        chmod                                                777         /usr/src    &&
announce    'Cloning git repo...           '                                             &&
git         clone https://github.com/scala-network/XLArig.git                            &&
announce     'Creating build folder...      '                                             &&
mkdir       XLArig/build                                                                 &&
announce    'Moving to build directory...  '                                             &&
cd          XLArig/build                                                                 &&
announce    'Building from source...       '                                             &&
cmake       ..                                                                           &&
make        -j$(nproc)                                                                   &&
announce    'Installing binary...          '                                             &&
sudo        cp xlarig /usr/local/bin/                                                    &&
announce    'Writing miner script...       '                                             &&
echo        -e '#!/bin/bash\n\nscreen -dmS xlacpu bash -c "xlarig -o us.fastpool.xyz:10126 -u '$WALLET'@'$WORKER\
    ' -p x -t '$THREADS' -a panthera -k"' > minexla.sh                                    &&
announce    'Making script executable...   '                                             &&
sudo        chmod +x minexla.sh                                                          &&
announce    'Installing miner script...    '                                             &&
sudo        cp minexla.sh /usr/local/bin/minexla                                         &&
announce     'Enter "minexla" to begin.     ' 