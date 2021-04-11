#!/bin/bash
set -xe

VERSION='0.14'
PI_MODEL=`tr -d '\0' < /proc/device-tree/model`
RPI_DEB="https://s3.setq.io/rockpi/deb/raspi-sata-${VERSION}.deb"
SSD1306="https://s3.setq.io/rockpi/pypi/Adafruit_SSD1306-v1.6.2.zip"

apt_install() {
  apt-get update -y
  apt-get install --no-install-recommends -y \
    python3-rpi.gpio \
    python3-setuptools \
    python3-pip \
    python3-pil \
    python3-spidev \
    pigpio \
    python3-pigpio
}

deb_install() {
  TEMP_DEB="$(mktemp)"
  curl -sL "$RPI_DEB" -o "$TEMP_DEB"
  dpkg -i "$TEMP_DEB"
  rm -f "$TEMP_DEB"
}

dtb_enable() {
  python3 /usr/bin/rockpi-sata/misc.py open_w1_i2c
}

pip_fixpath() {
  path="/usr/local/lib/python$(python3 -V | cut -c8-10)/dist-packages"
  if [ ! -d $path ]; then
    mkdir -p $path
  fi
}

pip_clean() {
  packages="Adafruit-GPIO Adafruit-PureIO Adafruit-SSD1306"
  for package in $packages; do
    if pip3 list 2> /dev/null | grep "$package" > /dev/null; then
      sudo -H pip3 uninstall "$package" -y
    fi
  done
}

pip_install() {
  pip_fixpath
  pip_clean

  TEMP_ZIP="$(mktemp)"
  TEMP_DIR="$(mktemp -d)"
  curl -sL "$SSD1306" -o "$TEMP_ZIP"
  unzip "$TEMP_ZIP" -d "$TEMP_DIR" > /dev/null
  cd "${TEMP_DIR}/Adafruit_SSD1306-v1.6.2"
  python3 setup.py install && cd -
  rm -rf "$TEMP_ZIP" "$TEMP_DIR"
}

main() {
  if [[ "$PI_MODEL" =~ "Raspberry" ]]; then
    apt_install
    pip_install
    deb_install
    dtb_enable
  else
    echo 'nothing'
  fi
}

main
