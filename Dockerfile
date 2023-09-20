FROM alpine:3.18

LABEL "org.opencontainers.image.authors"="StevenLooman"
LABEL "org.opencontainers.image.source"="https://github.com/StevenLooman/gitlab-cicd-magik-lint"
LABEL "version"="1.0.0"

ENV MAGIK_LINT_BASE_PATH /usr/local/lib/magik-lint
ENV MAGIK_LINT_DOWNLOAD_BASE_URL https://github.com/StevenLooman/magik-tools/releases/download
ENV REVIEWDOG_DIR /usr/local/bin/
ENV REVIEWDOG_PATH ${REVIEWDOG_DIR}/reviewdog
ENV REVIEWDOG_VERSION v0.15.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache curl=8.2.1-r0 openjdk17-jre-headless=17.0.8_p7-r0 git=2.40.1-r0

# Download magik-lint versions, saves a download for each run.
RUN mkdir -p ${MAGIK_LINT_BASE_PATH}
RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.7.1.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.7.1/magik-lint-0.7.1.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.7.0.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.7.0/magik-lint-0.7.0.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.6.0.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.6.0/magik-lint-0.6.0.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.5.4.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.5.4/magik-lint-0.5.4.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.5.3.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.5.3/magik-lint-0.5.3.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.5.2.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.5.2/magik-lint-0.5.2.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.5.1.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.5.1/magik-lint-0.5.1.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.5.0.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.5.0/magik-lint-0.5.0.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.4.0.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.4.0/magik-lint-0.4.0.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.3.2.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.3.2/magik-lint-0.3.2.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.3.1.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.3.1/magik-lint-0.3.1.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.3.0.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.3.0/magik-lint-0.3.0.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.2.0.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.2.0/magik-lint-0.2.0.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.1.4.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.1.4/magik-lint-0.1.4.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.1.3.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.1.3/magik-lint-0.1.3.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.1.2.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.1.2/magik-lint-0.1.2.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.1.1.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.1.1/magik-lint-0.1.1.jar
#RUN curl -sfL -o ${MAGIK_LINT_BASE_PATH}/magik-lint-0.1.0.jar ${MAGIK_LINT_DOWNLOAD_BASE_URL}/0.1.0/magik-lint-0.1.0.jar

# Install reviewdog.
RUN curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b ${REVIEWDOG_DIR} ${REVIEWDOG_VERSION}

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
