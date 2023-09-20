#!/bin/sh -l

set -eu

# Validate INPUT_MAGIK_TOOLS_VERSION is a valid version number.
MAGIK_TOOLS_VERSION="${INPUT_MAGIK_TOOLS_VERSION:-0.7.1}"
echo "${MAGIK_TOOLS_VERSION}" |
if ! grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" > /dev/null; then
    echo "::error Invalid magik_tools_version: ${MAGIK_TOOLS_VERSION}!"
    exit 1
fi

MAGIK_LINT_FILENAME="magik-lint-${MAGIK_TOOLS_VERSION}.jar"
MAGIK_LINT_DOWNLOAD_URL="${MAGIK_LINT_DOWNLOAD_BASE_URL}/${MAGIK_TOOLS_VERSION}/${MAGIK_LINT_FILENAME}"
MAGIK_LINT_PATH="${MAGIK_LINT_BASE_PATH}/${MAGIK_LINT_FILENAME}"
MAGIK_LINT_DEBUG=""
MAGIK_LINT_MSG_TEMPLATE="\${path}:\${line}:\${column}:\${msg} (\${symbol})"
MAGIK_LINT_COLUMN_OFFSET="+1"
SOURCE_PATH="${CI_PROJECT_DIR}"

RUNNER_DEBUG="${INPUT_RUNNER_DEBUG:-0}"
[ "${RUNNER_DEBUG}" = "1" ] && MAGIK_LINT_DEBUG="--debug" || MAGIK_LINT_DEBUG=""

export REVIEWDOG_GITLAB_API_TOKEN="${REVIEWDOG_GITLAB_TOKEN}"

# Download magik-lint if needed.
if [ ! -f "${MAGIK_LINT_PATH}" ]; then
    echo "::group:: Fetching ${MAGIK_LINT_FILENAME}"
    echo "Downloading ${MAGIK_LINT_FILENAME} from ${MAGIK_LINT_DOWNLOAD_URL}"
    curl -sfL -o "${MAGIK_LINT_PATH}" "${MAGIK_LINT_DOWNLOAD_URL}"
    echo "::endgroup::"
fi

# Run magik-lint + reviewdog.
java \
    -jar "${MAGIK_LINT_PATH}" \
    --column-offset "${MAGIK_LINT_COLUMN_OFFSET}" \
    --msg-template "${MAGIK_LINT_MSG_TEMPLATE}" \
    "${MAGIK_LINT_DEBUG}" \
    "${SOURCE_PATH}" \
    | "${REVIEWDOG_PATH}" \
        -efm="%f:%l:%c:%m" \
        -name="magik-lint" \
        -reporter="${INPUT_REPORTER:-gitlab-mr-discussion}" \
        -level="${INPUT_LEVEL:-error}" \
        -filter-mode="${INPUT_FILTER_MODE:-added}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
        "${INPUT_REVIEWDOG_FLAGS:-""}"
