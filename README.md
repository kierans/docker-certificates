# docker-certificates

Image for doing work with SSL certificates

## Why?

Often in large organisations, the organisation manages the Certificate Authorities (CAs) used to sign other certificates the organisation issues. Use cases include HTTP(S) proxies, or SSL certificates issued for internally hosted software.

However, unless tools that use SSL/HTTPS are told to trust the organisation's CAs, the tools will refuse to use SSL. Disabling/turning off certificate validation is a common workaround, but is a MASSIVE security problem as it defeats the purpose of using SSL certificates ie: establishing a trust relationship between client and server. The proper solution is to tell the tool to trust the CAs.

This image contains tools to help work around these use cases.

### Installing custom Certificate Authorities

There is often a "chicken and egg" problem when building a Docker image that you need to install custom CAs for the package manager to then install tools to install custom CAs. For example the [update-ca-certificates][1] tool is used to install custom CAs into a global location that tools like `curl` or package managers use by default. However, in some Linux Docker images the `update-ca-certificates` isn't installed in the image.

The workaround is to use Docker's [multi-stage builds][2] to create a "CA builder" copying the results into another image.

```Dockerfile
FROM kierans777/docker-certificates as ca-builder

COPY ./certs/*.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

# ---

FROM some-other-image

COPY --from=ca-builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Rest of Dockerfile

```

[1]: https://manpages.debian.org/buster/ca-certificates/update-ca-certificates.8.en.html
[2]: https://docs.docker.com/build/building/multi-stage/


