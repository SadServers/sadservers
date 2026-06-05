# **Cabedelo**: Harbor full of issues

## Description

You need to build and push a docker image **without changing the Dockerfile** to your company's Harbor registry, which is running at _harbor.sadservers.local_, with its home directory at _/opt/harbor_. You have full admin access with `admin:Harbor12345` credential. The source code and the Dockerfile are in the _~/app_ directory. The image name must be _harbor.sadservers.local/images/app:1.0.0_. It is also expected that the application will be up and running at `localhost:5000` in a container named _app_.

**IMPORTANT**. Do not:

1. Generate new internal certificates
1. Change the Dockerfile
1. Change the _/opt/harbor.yml_ file

## Test

1. Remove the local docker image and pull the application image from Harbor:

    ```bash
    docker rmi harbor.sadservers.local/images/app:1.0.0
    docker pull harbor.sadservers.local/images/app:1.0.0
    ```

1. `curl` the application:

    ```bash
    curl localhost:5000
    # Hello world!
    ```
