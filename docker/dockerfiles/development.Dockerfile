## TFLINT
FROM registry.gitlab.com/gitlab-org/terraform-images/releases/1.1:latest as tflint-builder

LABEL maintainer="Arnau Llamas <arnau.llamas@gmail.com>"

WORKDIR /dist

ARG BUILD_PACKAGES="\
  unzip \
  sudo \
  bash \
  "

RUN apk add --no-cache ${BUILD_PACKAGES}

RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash \
  && mv /usr/local/bin/tflint .

## TFSEC
FROM golang:latest as tfsec-builder

RUN go install github.com/aquasecurity/tfsec/cmd/tfsec@latest

## DEV
FROM registry.gitlab.com/gitlab-org/terraform-images/releases/1.1:latest

WORKDIR /code

ARG DEV_PACKAGES="\
  make \
  bash \
  gettext \
  moreutils \
  "

ARG USERNAME
ARG USER_UID
ARG USER_GID

COPY --from=tfsec-builder /go/bin/tfsec /bin/tfsec
COPY --from=tflint-builder /dist/tflint /bin/tflint

RUN apk add --no-cache ${DEV_PACKAGES}

RUN addgroup -g $USER_GID $USERNAME \
  && adduser -u $USER_UID -D -s /bin/sh $USERNAME -G $USERNAME \
  && chown -R $USER_UID:$USER_GID /home/$USERNAME

USER ${USERNAME}

ENTRYPOINT ["tail", "-f", "/dev/null"]
