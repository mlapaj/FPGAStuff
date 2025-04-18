#!/bin/bash
rm -rf /luna
mkdir /luna
cd /luna
# download openFpgaLoader !! WARNING - they are using ubtuntu instead ubuntu :-)
curl -L $(curl -s https://api.github.com/repos/trabucayre/openFPGALoader/releases/latest\
    | jq -r '.assets[] | select(.name | test("ubtuntu"))|.browser_download_url')\
    --output openFpgaLoader.tgz
tar -C / -xf openFpgaLoader.tgz

# clone repos
git config --global user.email "agent007@mi6.uk"
git config --global user.name "James Bond"

git clone https://github.com/amaranth-lang/amaranth --branch v0.4.0 --single-branch
git clone https://github.com/mlapaj/amaranth-boards-tang-primer-20k-luna --branch last_compatible_04 --single-branch
git clone https://github.com/greatscottgadgets/luna.git  --branch 0.1.3 --single-branch
git clone https://github.com/mlapaj/luna-boards-tang-primer-20k
cd amaranth
pip install .
cd ..
cd luna
git revert cf6abaa
pip install .
cd ..
cd luna-boards-tang-primer-20k
pip install .
cd ..
cd amaranth-boards-tang-primer-20k-luna
pip install .


# this is for gowin only

# working
pip install yowasp-yosys==0.47.0.0.post805
pip install yowasp-nextpnr-gowin==0.7.0.11.post528.dev0
pip install amaranth-yosys==0.40.0.0.post100
# temporary

