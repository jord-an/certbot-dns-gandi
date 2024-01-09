FROM certbot/certbot:latest

RUN pip install certbot-plugin-gandi
COPY ./certbot.sh /app/certbot.sh

ENTRYPOINT ["/app/certbot.sh"]
# Set ENV variable GANDI_TOKEN which is overwritten using the -e variable when running docker.
ENV GANDI_TOKEN GANDI_API_TOKEN
