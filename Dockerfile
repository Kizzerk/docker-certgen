FROM debian:latest

COPY catcerts.sh /catcerts.sh

RUN chmod +x /catcerts.sh

VOLUME /znc-data
VOLUME /znc-cert

USER root

CMD ["/catcerts.sh"]


