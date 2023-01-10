FROM nginx:1.23.3

RUN cat /etc/os-release
RUN groupadd gitlab-www -g 998
RUN useradd gitlab-www -u 997 -g gitlab-www
RUN apt-get update && apt-get -y install nginx-extras
RUN nginx -V
RUN nginx -v
CMD ["nginx","-p","/var/opt/gitlab/nginx", "-c", "conf/nginx.conf"]
