# CP for Integration

[Knowledge Center](https://www.ibm.com/support/knowledgecenter/SSGT7J)

[Deployment Guide](https://cloudpak8s.io/integration/introduction/)

# Areas

* API Connect, implementing managed APIs
* App Connect Enterprise, providing integration workflows
* MQ Advanced, for robust guaranteed transport
* Event Streams, for event handling based on Kafka
* DataPower Gateway, for gateway services.
* Aspera High Speed Transfer Server, for large file transfers

# How to deploy CP for integration

I created some simple scripts to deploy this CP:

* [Unzip CP Image](unzip_image.sh)
* [Install Docker](install_docker.sh)
* [Install CP 4 Integration](install_cp4i.sh)

# Sizing

Version 3.2

## Cloud Pak for Integration

| Phase | CPU | Memory |
|---|---|---|
| Before CP for Integration | 2427m | 16121Mi |
| After installing CP for Integration | 3491m | 22492Mi |
| *Delta* | 1064m | 6371Mi |

## API Connect

| Phase | CPU | Memory |
|---|---|---|
| Before API Connect | 7151m | 36655Mi |
| After installing API Connect |  |  |
| *Delta* | 1064m | 6371Mi |
