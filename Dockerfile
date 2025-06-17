FROM scratch

ARG version

RUN wget https://github.com/Qubitol/playground/releases/download/$version/playground.tar.gz
RUN tar -xzf playground.tar.gz
