FROM debian:latest

COPY catcert.sh

RUN chmod +x catcert.sh

VOLUME /znc-data
VOLUME /znc-cert

CMD ["catcert.sh"]

