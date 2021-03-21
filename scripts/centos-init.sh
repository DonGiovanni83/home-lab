#!/bin/bash
# Script to setup ansible on centos 8
# 1. install python 3.8
# 2. install ansible using pip3
# 3. create ansible user
# 4. setup ssh
#

if [ $EUID -ne 0 ]; then
    echo "Run as root"
    exit 1
fi

echo "Installing requirements..."

yum update -y
yum upgrade -y
yum groupinstall "Development Tools" -y
yum install -y \
    wget \
    openssl-devel \
    bzip2-devel \
    libffi-devel

# install python 3.8
echo "Installing python 3.8"
wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tar.xz
tar xf Python-3.8.0.tar.xz
cd Python-3.8.0 || exit 1
./configure --enable-optimizations
make altinstall
cd ..
rm -rf Python-3.8.0*

echo -e 'export PATH=$PATH:/usr/local/bin' >>/etc/profile
ln -sf /usr/local/bin/python.3.8 /usr/bin/python
ln -sf /usr/local/bin/pip3.8 /usr/bin/pip

# install ansible
echo "Installing ansible"
python -m pip install ansible

# create ansible user
echo "Creating and setting up ansible user"
useradd -m ansible
usermod ansible -aG sudo
#visudo /etc/sudoers.d/010_ansible_nopasswd
echo "ansible ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/010_ansible_nopasswd

mkdir /home/ansible/.ssh
cat >/home/ansible/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQlsFPr+FPb3Q37H0adf5ngIm4oSoo6t54HMnFX10hiGy5YE0SXZQ7v5Uk5sO4SF3VpkMdyzdnVC3dQt3HvJzXwFncaGuMjyi7zCSMXnyx1Itx5pcd3Z13YxDDQlSOhBp7z11t3rpEljsCF9L4HrG3T305lTmZB3w5iRbQTf2wNQYVOsDEJeONQOD1Vn3AjK8ht1AvZvhkFBxyUPtYxzWmQzTioYRe+yJkTbmGLV42l8oQA8yVjFxdDk8NfzhhF6KGfyxyIo+kDban3b+TtCmznys1GwGCg/YWUWQMLpnQW9LDzUuo7pOzyY1fukyzae0mITuiGjjJtPqvvm1Oj8vFh2dEve2ZfIAPBRjQ6buCWaXk0ML0UiwmVCXtOGUAWMpxe9dBH5O5sChHDRLywR22w1Dl24/xXaO8W5H9n3KWIXclfTm9CxJBV/gJjB+WQmhSSaX5z+tvgdaZRxE4pzUyGKsJiS3x50tej8zLllrBvm8hkPlVTKCdz7uS/r8g5Sc= fbertagna@fbertagna-puzzle
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpPUlo6xZcVvkEauG4ET3jvkPjiSSRgXzm1Kq5hCYiAJ2k8aTnr8SigNrsvRuCYo/O46itmVJ3aawtBS5+K0AZP/gDoXdEZ8bv4DBf2XpehLUBSRC9r0Zcu/7zYe/rI1NDJyR5kZOP6QiIAaqtCXgyz/iTN7KH59BudQbG2IHnoAnaOaqWgnt8Oi70VzefN2iG/JQbntFFlUytMvlycW2n1hfBftsWzWeguLCklDd5DwlOef4jMNhJQpJTAKk3WWqm1v/aRw99weS1lX5bVm/IEjL3l0VTW5b9cNmO2etdSlLbznyFDmyyXfEHGgoULlToxNDWnEG5dxyxwHILXJYWiBZVGg1gtkk2mOOKquTbqROMTqu2VdPiIefw362+oKiqlk1uV1FJ5Q0JCwVrEU4Nv9bUeN/z0iwkGaL2J+457qXQdCvvLrpJHuRBqpW0ekSslG7OZFvznAMbnuopzQHOs3TNUHxM4fwV1LZjnHL0Ej5jzyBjUWZGOKeGz5dAiBc= fbertagna@fbertagna-puzzle
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3oNXwK2I57kXQe2xcRFjHj1yTy5uXTFSXROKztEOGrZh0+FGt0k6cbIhlNTPY61x6eZj1mvwhXGl3G7l2fbkk7jRir1KQL1n3lZRP5pX8s8qa98mq+R16rrVO+7JYkzlOSzzAVAH2bvYMf3aqZlqHNaDUabCI91l0B5WxdR93iS7XZZvQWYzoSflIQnGDYnC55STPISxrL6X4BsgF/X9b75FOQSDJv2L6pRIpJYr/AN4iCrMJnh/WiJOiooeuUiZEJdrvD7BC5MxGEKUJunG8aPH4Rga+OuUq2YoNtFGBW2R94y62JXEAN1HlB1dRKy6WFFEA/wM3G3yWw0SvMVy6+N+ffdpSjAh1bbhDbMuSIxCPR0oLdPsqx5egOHb94784HcwRfsKjS7IQZ6cYLJKyzf4tSAf8PghnDt5ZpBC5HA1VAawiiMIf2SdaWQC6c/RrADDuPsPhPSrrJ7tx7t9PaMvL3yrM7u1sb5BVkyDw1Y3sTsxQ9D6MexquBvBhynk= bertagna@puzzle.chs
sh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsxrHRueojo71wSAL4o1OsXwyV5xfyAl9eNLCssK5z1ML5pGnVxpMjjC/cuVDh7XqjS8mDv3zgDBvPi7AJY6RHQRgQGFFwtPfOijvBWQDBLkv9MnDaisGtytj0amY3bKyyLDVXJq4KqensWRbNU/W+PH0+LXtv9GKez9FSf+bWHwHf6NNLQIR/goqayIS4tPYqV2ojPYUihVCUj4PXOMxm3tZkCi1oJINF/cFnpS1nPM9vu2Wt4OBYLLg6G2FvxsX7/6/6TopeObzJmagHOkj8G9VoNmhx06LBGe1WwkLDRiwGxtZy9GFqg9R6uqWcMr1MLObV7hKE++3DXigYXXbzRCkO3wTgi7RrQcfjGbL6C6NWhFx2hG18hHl88zF7W31lmI7h70JUovFubuNbzDuAic9rEuUVJTxmwRssGp2Q/eccf1r6OP1wWNpJsdwjy54E7NJ+KSKDXua2E05WXF7YIKRseaSVnZ5yRJIe0rAbtfpL7EotiRwkFouUzilgXpc= fabio@fabio-ThinkPad-T480s
EOF
chmod 600 /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh
