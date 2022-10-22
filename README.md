**Note: Docker deployment of openQA isn't meant for production. Use it for testing purposes only.**

---

# Get docker images

You can either build the images locally, or get our "latest stable" version from the Docker hub. We recommend using the Docker hub option.

## Download images from the Docker hub

    docker pull fedoraqa/openqa_server
    docker pull fedoraqa/openqa_worker

## Build images locally

    docker build -t fedoraqa/openqa_server:latest ./server
    docker build -t fedoraqa/openqa_worker:latest ./worker

# Running openQA

We've tried to make openQA deployment with Docker as easy as possible, but there are still some additional steps needed.

## Create Docker network

    docker network create --driver bridge openqa_nw

This will create Docker network called `openqa_nw`, so that Docker containers could communicate with each other.

## Create shared files

Next step is to create directory for ISOs, HDDs and tests. Create directory somewhere on your host system:

    mkdir -p ~/openqa/shared

Put your openQA tests (for example from here: https://pagure.io/fedora-qa/os-autoinst-distri-fedora) into `test` subdirectory:

    mkdir ~/openqa/shared/tests
    git pull https://pagure.io/fedora-qa/os-autoinst-distri-fedora ~/openqa/shared/tests/fedora

For ISOs, create `factory/iso` subdirectory of your shared directory, for HDDs, create `factory/hdd`:

    mkdir -p ~/openqa/shared/factory/iso
    mkdir -p ~/openqa/shared/factory/hdd

For authentication, you need to save key and secret somewhere. Copy `client.conf.template` to some place in your system:

    cp client.conf.template ~/openqa/client.conf

It is also necessary to set selinux properly:

    chcon -Rt svirt_sandbox_file_t ~/openqa

## Run server container

Now you can run openQA server with:

    docker run -d -p 8080:80 --name server -v ~/openqa/shared:/var/lib/openqa/share -v ~/openqa/client.conf:/etc/openqa/client.conf --network=openqa_nw fedoraqa/openqa_server

This will start openQA on port 8080.

### API keys and authentication

Because Docker deployment is only meant for testing and development purposes, "fake" authentication is used. This means that you don't have to provide login and password when you try to login into web UI.

For authentication between server and workers, system with keys and secrets is used. Login through your web browser on http://localhost:8080, click on "Manage API keys", generate new key/secret pair and put them into `~/openqa/client.conf` file.

## Run the Worker container

    docker run --privileged -v ~/openqa/shared:/var/lib/openqa/share -v ~/openqa/client.conf:/etc/openqa/client.conf --network=openqa_nw --name worker1 -h worker1 fedoraqa/openqa_worker

Check whether the worker connected in the web UI's administration interface.

To add more workers, increase number that is used in hostname and container name and add worker number at the end of the command, so to add worker 2 use:

    docker run --privileged -v ~/openqa/shared:/var/lib/openqa/share -v ~/openqa/client.conf:/etc/openqa/client.conf --network=openqa_nw --name worker2 -h worker2 fedoraqa/openqa_worker 2

## Populate the openQA's database:

To load templates, run:

    docker exec server /var/lib/openqa/tests/fedora/templates

# Running jobs

After performing the "setup" tasks above, you can schedule a test like this:

    docker exec server /var/lib/openqa/script/client isos post ISO=Fedora-Server-netinst-x86_64-22_Beta_RC3.iso DISTRI=fedora VERSION=rawhide FLAVOR=generic_boot ARCH=x86_64 BUILD=22_Beta_RC3

Alternatively, because openQA's server is exposed to your host system, you can schedule tests using openQA's API. Use key and secret you've generated, openQA resides on http://localhost:8080.
