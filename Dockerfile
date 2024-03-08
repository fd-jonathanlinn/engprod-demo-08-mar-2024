FROM bash:latest

COPY . /workdir

RUN chmod +x /workdir/ci/generate-steps.sh

CMD /workdir/ci/generate-steps.sh
