FROM opencpu/base
RUN apt-get -y update
RUN apt-get -y install git
RUN sed -i 's/"rlimit.nproc":.*/"rlimit.nproc": 100,/' /etc/opencpu/server.conf
RUN apt-get -y install libcairo2-dev
RUN apt-get -y install libxt-dev
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite("Biobase"); library(devtools); install_github("baba-beda/morpheusR"); install_github("hadley/scales")'
RUN a2dissite opencpu
RUN R -e 'opencpu::opencpu$start(8001)'
RUN touch /etc/apache2/sites-available/opencpu2.conf
RUN printf "ProxyPass /ocpu/ http://localhost:8001/ocpu/\nProxyPassReverse /ocpu/ http://localhost:8001/ocpu\n" >> /etc/apache2/sites-available/opencpu2.conf
RUN a2ensite opencpu2
RUN printf "\nServerName localhost\n" >> /etc/apache2/apache2.conf
RUN printf "*\t soft \t nofile \t 8192\n*\t hard \t nofile \t 8192\n" >> /etc/security/limits.conf 
RUN apache2ctl configtest
RUN apache2ctl graceful
RUN service apache2 reload
RUN service apache2 status
RUN cd /var/www/html && \
    git clone https://github.com/baba-beda/morpheus.js.git morpheus && \
    cd
