FROM opencpu/base
RUN \
    apt-get -y update && \
    apt-get -y install git && \
    R -e 'source("https://bioconductor.org/biocLite.R"); biocLite("Biobase"); biocLite("ggplot2"); biocLite("ggrepel"); library(devtools); install_github("baba-beda/morpheusR"); install.packages("svglite", repos = "http://cran.us.r-project.org")' && \
    cd /var/www/html && \
    git clone https://github.com/baba-beda/morpheus.js.git morpheus && \
    cd 
