#### Các ghi chú trong khi setup repos

#### Chú ý

- Có 2 cách setup:
  - Setup sử dụng apt-mirror (download hết rất cả các package của Distro về)
  - Sử dụng apt-cache-ng (tải đến đâu thì download về đến đó)
  
#### Cài đặt apt-mirror

- Cài Apache
```sh
sudo apt-get -y install apache2
```

- Cài `apt-mirror`
```sh
sudo apt-get -y install apt-mirror
```

- Tạo thư mục chứa các package của distro 
```sh
sudo mkdir /linoxide
```

- Mở file /etc/apt/mirror.list
```sh
sudo vi /etc/apt/mirror.list
```

- Khai báo cho file vừa tạo nội dung như sau. Chú ý đường dẫn tới thư mục đã tạo (trong ubuntu 14.04-3 nằm ở dòng số 3)
```sh
############# config ##################
#
# set base_path /var/spool/apt-mirror

set base_path /linoxide

#
# set mirror_path $base_path/mirror
# set skel_path $base_path/skel
# set var_path $base_path/var
# set cleanscript $var_path/clean.sh
# set defaultarch <running host architecture>
# set postmirror_script $var_path/postmirror.sh
# set run_postmirror 0
set nthreads 20
set _tilde 0
#
############# end config ##############

deb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse

### Danh cho Ubuntu 14.04 32 bit 
deb-i386 http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse

#deb http://archive.ubuntu.com/ubuntu trusty-proposed main restricted universe multiverse
#deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse

deb-src http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu trusty-proposed main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse
clean http://archive.ubuntu.com/ubuntu
````

- Chạy lệnh dưới để bắt đầu download các package cho distro
```sh
sudo apt-mirror
```


- Thiết lập crontab để download định kỳ các package mới nhất
```sh
đang update
```

- Sau khi thực hiện lệnh trên, máy sẽ download các package từ internet về và đặt tại thư mục /linoxide. Có thể kiểm tra dung lượng thư mục này bằng lệnh `du -sch` và xem các thư mục con bằng lệnh `ls /linoxide`

```sh
cd /linoxide
du -shc

hoặc 

ls /linoxide
```

- Tạo liên kết từ thư mục chứa package tới thư mục vừa tạo ở trên
```sh
sudo ln -s /linoxide/mirror/archive.ubuntu.com/ubuntu ubuntu

```

- Cấu hình crontab để định kỳ tải package từ kho của ubuntu về
- Sửa file `sudo vi /etc/cron.d/apt-mirror` và khai báo vào lúc 2AM hàng ngày thực hiện đồng bộ.

```sh
#
# Regular cron jobs for the apt-mirror package
#
0 2 * * * apt-mirror /usr/bin/apt-mirror > /var/spool/apt-mirror/var/cron.log
```

### CLIENT
- Trên client, xóa file gốc và tạo file mới `/etc/apt/sources.list` với nội dung dưới

```sh
deb http://172.16.69.238/ubuntu trusty universe
deb http://172.16.69.238/ubuntu trusty main restricted
deb http://172.16.69.238/ubuntu trusty-updates main restricted
```

hoặc

```sh
cp /etc/apt/sources.list /etc/apt/sources.list.bak
rm /etc/apt/sources.list 
cat << EOF > /etc/apt/sources.list 
deb http://172.16.69.238/ubuntu trusty universe
deb http://172.16.69.238/ubuntu trusty main restricted
deb http://172.16.69.238/ubuntu trusty-updates main restricted
EOF
```

#### Link tham khảo

1. http://www.unixmen.com/setup-local-repository-in-ubuntu-15-04/
2. http://www.tecmint.com/setup-local-repositories-in-ubuntu/
3. http://linoxide.com/ubuntu-how-to/setup-local-repository-ubuntu/

### Cách 2: Cài đặt APT-CACHE-NG
#### Trên Server 
- Cài đặt apache
```sh
apt-get -y install apache2
```

- Cài đặt apt-cache

```sh
apt-get -y install apt-cacher
```

- Có thể cấu hình dòng `allowed_hosts` trong file ` /etc/apt-cacher/apt-cacher.conf` để cho phép máy nào được sử dụng apt-cache

##### Trên client 
- Chạy dòng sau để khai báo repos
```sh
echo '"Acquire::http::Proxy "http://IP_CUA_MAY_APT_CACHE:3142";' >  /etc/apt/apt.conf.d/01proxy
"
```
- Chạy lệnh `apt-get update` trước khi cài các gói phần mềm

#### Phần quản trị
- Truy cập vào web của máy chủ cài apt-cache theo link http://IP_MAY_CHU_APT_CACHE:3142



#### Nhật ký  thay đổi dung lượng thư mục repos
09/12/2015: 182G















