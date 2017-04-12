FROM debian:latest

COPY catcerts.sh /catcerts.sh

RUN chmod +x /catcerts.sh

VOLUME /znc-data
VOLUME /znc-cert

CMD ["/catcerts.sh"]


