Local-Repository
================
##I. Thông tin LAB
Tạo Local Repository để cài đặt OpenStack thông qua mạng LAN <br>
Việc này rất hữu dụng để cài đặt triển khai những hệ thống cần có sự đồng bộ về phiên bản của các gói cài đặt, 
giảm thời gian triển khai do bớt được thời gian download các gói, tiết kiệm băng thông cho hệ thống. <br>

![Mô hình LAB](https://github.com/trananhkma/image/blob/master/Screenshot%20from%202014-11-20%2015:38:37.png)
Ý tưởng của bài LAB là cấu hình máy server thành nơi chứa repo, client sẽ cài đặt các gói phần mềm thông qua repo này, không kết nối với internet.
##### Chuẩn bị:
- 2 máy ảo chạy ubuntu server 14.04 lần lượt đóng vai trò là server và client
- Trên máy server có 2 card mạng một card kết nối internet, một card nối với client
- Trên máy clien do mục đích của bài LAB là cài thử nghiệm OpenStack AIO nên các bước chuẩn bị [**tại đây**](https://github.com/vietstacker/icehouse-aio-ubuntu14.04/blob/master/hd-caidat-openstack-icehouse-aio.md)
- Trên mô hình chỉ có 1 card cho client do đã disable card ra internet

##II. Các bước cài đặt
###1. Cài đặt server
Đầu tiên cài đặt apache:

    apt-get install apache2

Tạo thư mục chứa repo. Ở đây tôi sử dụng /var/www/html/myrepo/

    mkdir /var/www/html/myrepo/

Bước tiếp theo, copy toàn bộ file và thư mục trong /var/cache/apt/archives/ từ một máy đã cài sẵn OpenStack AIO vào thư mục chứa repo của server của bạn tại /var/www/html/myrepo/ đã tạo ở bước trên.
Có nhiều cách để thực hiện điều này, đơn giản nhất là dùng lệnh scp. Cú pháp scp [**tại đây**](https://github.com/trananhkma/trananhkma/blob/master/SCP%20command.md). <br>

Cuối cùng, vào nơi chứa repo, tạo file Packages.gz để khi client chạy lệnh update, nó sẽ đọc file này và biết được danh sách các gói có trong repo. Thực hiện như sau:

    cd /var/www/html/myrepo/
    dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

Câu lệnh dpkg-scanpackages yêu cầu cần có gói "dpkg-dev" mới chạy được, nếu chạy lệnh bị lỗi, cài gói này rồi chạy lại.<br>
Mỗi lần muốn download hay copy thêm gói mới, ta phải thực hiện lại bước này để update cho gói Packages.gz. Để cho tiện, nên tạo một file script để thực hiện update repo với nội dụng như sau:

    #! /bin/bash
    cp /var/cache/apt/archives/* /var/www/html/myrepo
    cd /var/www/html/myrepo
    dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

Sau này mỗi khi muốn thêm vào repo các gói đã cài trên server chỉ cần chạy script này. <br>
Hoàn thành cài đặt server
###2. Cài đặt client
Trên client thì việc cấu hình đơn giản hơn rất nhiều, chỉ cần thay đổi một chút trong file source. <br>
Mở file etc/apt/sources.list thêm dòng repo trỏ đến repo đã tạo trên server:

    deb http://192.168.10.128/myrepo ./

Đồng thời bỏ đi tất cả các repo khác bằng cách thêm dấu # đầu dòng. <br>
Tiếp theo update repo:

    apt-get update

Sau khi chạy lệnh này, client sẽ đọc đc file Packages.gz ở server và biết được trong repo có những gói nào. <br>
Bây giờ có thể cài đặt OpenStack AIO theo script một cách nhanh chóng mà không cần kết nối internet. Điều kiện là client đã có những script này.<br>
***Một lưu ý*** là khi thực hiện cài đặt gói ở client, hệ thống sẽ đòi xác thực lại là có muốn tải file về hay không? Điều này sẽ làm cho những câu lệnh tải gói có biến ***-y*** trong script ***bị lỗi***. Do đó cần sửa script để xoá các biến -y này! Khi đến các bước tải gói cần phải ***xác nhận thủ công***. <br>
Hoàn thành bài lab.
<br>
<br>
***Update:*** Đối với trường hợp trên, không nhất thiết phải xác nhận thủ công như vậy, bạn có thể thêm tùy chọn ***--force-yes*** vào mỗi câu lệnh cài đặt. Tùy chọn này sẽ bỏ qua mọi cảnh báo khi cài đặt, do đó hệ thống sẽ không đòi xác nhận nữa. Tuy nhiên, cần thận trọng khi sử dụng tùy chọn này vì nó có thể gây nguy hại cho hệ thống. <br>
Trích lệnh ***man***: Using force-yes can potentially destroy your system!



