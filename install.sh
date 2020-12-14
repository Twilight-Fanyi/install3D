#!/bin/bash
echo "**********************************************************"
echo "             3D平台安装，Ubuntu18.04 LST "
echo "             合肥师范学院     缪新宇"
echo " ！！！！！！！！文件夹的路径中不可以出现中文！！！！！！！！"
echo "**********************************************************"

# backup the original sources.list
if [ ! -e "/etc/apt/sources.list.backup" ]
then sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
fi

#replcae sources.list
sudo cp sources18.list /etc/apt/sources.list

#after replace we should update
sudo apt-get update
sudo apt-get upgrade


#insatall dependencies
sudo apt-get install kdevelop cmake subversion libfreetype6-dev libode-dev libsdl1.2-dev ruby ruby-dev libdevil-dev libboost-dev libboost-thread-dev libboost-regex-dev libboost-system-dev qt4-default openjdk-8-jdk build-essential libgl1-mesa-dev automake libtool -y

echo "**********************************************************"
echo "                   安装ODE"
echo "**********************************************************"
cd ode-0.16.1
chmod +x configure
./configure --enable-shared --disable-demos --enable-double-precision --disable-asserts --enable-malloc
make
sudo make install
sudo ldconfig
cd ..

echo "**********************************************************"
echo "                   安装simspark"
echo "***********************************************************"
cd simspark-0.3.1
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig
cd ../..

echo "**********************************************************"
echo "                  安装rcsssever"
echo "**********************************************************"
cd rcssserver3d-0.7.2
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig

# Configure library paths
echo -e '/usr/local/lib/simspark\n/usr/local/lib/rcssserver3d' | sudo tee /etc/ld.so.conf.d/spark.conf
sudo ldconfig

cd ../..

echo "**********************************************************"
echo "                  安装roboviz"
echo "**********************************************************"
cd RoboViz-1.7.0/scripts/
chmod +x *.sh
./build.sh
cd ../..

#path replace so you can open roboviz in the desktop
ADir="\$bindir/rcssmonitor3d"
BDir="$( cd RoboViz-1.7.0/bin && pwd)/roboviz.sh"
sudo sed -i "s#$ADir#$BDir#" /usr/local/bin/rcsoccersim3d

#in the end we clean
sudo apt-get clean
sudo apt-get autoclean

#install is over so we can start
rcsoccersim3d&
