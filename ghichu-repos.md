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
sudo mkdir /myrepo
```

- Tạo file /etc/apt/mirror.list
```sh
sudo vi /etc/apt/mirror.list
```

- Khai báo cho file vừa tạo nội dung như sau. Chú ý đường dẫn tới thư mục đã tạo
```sh
############# config ##################
#
# set base_path /var/spool/apt-mirror

set base_path /myrepo

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




#### Link tham khảo
1. http://www.tecmint.com/setup-local-repositories-in-ubuntu/
2. http://www.unixmen.com/setup-local-repository-in-ubuntu-15-04/
3. http://linoxide.com/ubuntu-how-to/setup-local-repository-ubuntu/
