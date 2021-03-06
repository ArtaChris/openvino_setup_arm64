sudo -E apt install -y \
        build-essential \
        ffmpeg-dev \
        git \
        libgtk2.0-dev \
        pkg-config \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libgstreamer-plugins-base1.0-dev

cd ~/
wget https://github.com/Kitware/CMake/releases/download/v3.14.7/cmake-3.14.7.tar.gz
sudo tar xvzf cmake-3.14.7.tar.gz
cd ~/cmake-3.14.7
sudo ./bootstrap
sudo make -j4
sudo make install
sudo rm -rf cmake-3.14.7 cmake-3.14.7.tar.gz

sudo pip3 install numpy cython

cd ~/
git clone https://github.com/opencv/opencv.git
cd opencv && mkdir build && cd build
sudo cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
sudo make -j4
sudo make install

cd ~/
git clone https://github.com/openvinotoolkit/openvino.git
cd ~/openvino/inference-engine
git submodule update --init --recursive
cd ~/openvino

sudo -E apt update
sudo -E apt install -y \
        build-essential \
        curl \
        wget \
        libssl-dev \
        ca-certificates \
        git \
        libboost-regex-dev \
        libgtk2.0-dev \
        pkg-config \
        unzip \
        automake \
        libtool \
        autoconf \
        libcairo2-dev \
        libpango1.0-dev \
        libglib2.0-dev \
        libgtk2.0-dev \
        libswscale-dev \
        libavcodec-dev \
        libavformat-dev \
        libgstreamer1.0-0 \
        gstreamer1.0-plugins-base \
        libusb-1.0-0-dev \
        libopenblas-dev
if apt-cache search --names-only '^libpng12-dev'| grep -q libpng12; then
    sudo -E apt install -y libpng12-dev
else
    sudo -E apt install -y libpng-dev
fi

sudo export OpenCV_DIR=/usr/local/lib
cd ~/openvino
mkdir build && cd build
sudo cmake -DCMAKE_BUILD_TYPE=Release \
           -DENABLE_MKL_DNN=OFF \
           -DENABLE_CLDNN=ON \
           -DENABLE_GNA=OFF \
           -DENABLE_SSE42=OFF \
           -DTHREADING=SEQ \
           -DENABLE_SAMPLES=ON \
           ..
sudo make -j4
sudo make install

cd ~/openvino/model-optmizer
pip3 install -r requirements.txt

sudo apt-get install protobuf-compiler libprotoc-dev
cd ~/
git clone https://github.com/onnx/onnx.git
cd onnx
git submodule update --init --recursive
python setup.py install

sudo apt install caffe-cpu

cd ~/
git clone https://github.com/tiran/defusedxml.git
cd ~/defusedxml
git submodule update --init --recursive
python setup.py install

cd ~/
git clone https://github.com/movidius/ncappzoo.git

cd ~/
mkdir ~/models
git clone https://github.com/openvinotoolkit/open_model_zoo.git
cd ~/open_model_zoo/tools/downloader
sudo python3 -m pip install --user -r ./requirements.in
sudo ./downloader.py --all --output_dir ~/models --precisions FP16 -j4

cd ~/models
wget https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin/age-gender-recognition-retail-0013/FP16/age-gender-recognition-retail-0013.xml
wget https://download.01.org/opencv/2019/open_model_zoo/R1/models_bin/age-gender-recognition-retail-0013/FP16/age-gender-recognition-retail-0013.bin
mkdir ~/OpenVINO/ && cd ~/OpenVINO
wget http://software.intel.com/content/dam/develop/external/us/en/documents/Setup%20Additional%20Files%20Package.tar.gz
sudo tar xvzf Setup\ Additional\ Files\ Package.tar.gz
sudo usermod -a -G users "$(whoami)"
sudo cp ~/OpenVINO/97-myriad-usbboot.rules_.txt /etc/udev/rules.d/97-myriad-usbboot.rules
sudo udevadm control --reload-rules
sudo udevadm trigger 
sudo ldconfig
