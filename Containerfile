FROM centos:8

MAINTAINER José Luis G.F.
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

#ENV container docker

# Install Apache
RUN yum -y install httpd mod_ssl
RUN yum -y install httpd-tools
RUN yum -y install openssl
RUN yum clean all -y
#RUN htpasswd -b -c /var/www/html/.htpasswd admin admin

COPY index.html /var/www/html/
COPY httpd.conf /etc/httpd/conf/
COPY htpasswd /var/www/html/.htpasswd
COPY htaccess /var/www/html/.htaccess
COPY ssl.conf /etc/httpd/conf.d/
RUN mkdir /etc/ssl/private/
COPY practicadevops.local.key /etc/ssl/private/
COPY practicadevops.local.crt /etc/ssl/certs/

RUN chown apache:apache /var/www/html/.htaccess
RUN chown apache:apache /var/www/html/.htpasswd
RUN chmod 644 /var/www/html/.htaccess /var/www/html/.htpasswd

#RUN cd /home/
#RUN openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout practicadevops.local.key -out practicadevops.local.crt -subj "/CN=practicadevops.local" -addext "subjectAltName=DNS:practicadevops.local"

#RUN cp /home/practicadevops.local.key /etc/ssl/private/
#RUN cp /home/practicadevops.local.crt /etc/ssl/certs/

RUN chmod 644 /etc/ssl/certs/practicadevops.local.crt
RUN chmod 600 /etc/ssl/private/practicadevops.local.key

RUN systemctl enable httpd.service

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 8080

CMD ["/usr/sbin/init"]
