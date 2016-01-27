FROM nginx:1.9.10

RUN apt-get update -qq && apt-get -y install wget unzip

ADD files /

EXPOSE 80

#Install Consul Template
RUN wget https://releases.hashicorp.com/consul-template/0.12.2/consul-template_0.12.2_linux_amd64.zip && unzip -d /usr/local/bin consul-template_0.12.2_linux_amd64.zip

CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf \
& consul-template \
  -consul=172.17.42.1:8500 \
  -template "/etc/consul-templates/nginx.conf:/etc/nginx/conf.d/app.conf:/usr/sbin/nginx -s reload" \
  -template "/etc/consul-templates/nginx-home.conf:/usr/share/nginx/html/index.html";