FROM node:6.11 as webapp
MAINTAINER omer.kushmaro@stratoscale.com

WORKDIR /
ADD clarity-seed-newfiles clarity-seed-newfiles

RUN npm install -g @angular/cli \
 && git clone https://github.com/vmware/clarity-seed.git \
 && cd /clarity-seed \
 && git checkout -b f3250ee26ceb847f61bb167a90dc957edf6e7f43 \
 && cp /clarity-seed-newfiles/src/index.html /clarity-seed/src/index.html \
 && cp /clarity-seed-newfiles/src/styles.css /clarity-seed/src/styles.css \
 && cp /clarity-seed-newfiles/src/app/app* /clarity-seed/src/app \
 && cp /clarity-seed-newfiles/src/resources/* /clarity-seed/src/images \
 && cp /clarity-seed-newfiles/src/environments/env* /clarity-seed/src/environments \
 && cp /clarity-seed-newfiles/package.json /clarity-seed/package.json \
 && cp /clarity-seed-newfiles/angular-cli.json /clarity-seed/angular-cli.json \
 && rm -r /clarity-seed/src/app/home \
 && rm -r /clarity-seed/src/app/about \
 && cd  /clarity-seed/src \
 && npm install \
 && ng build --environment=prod --output-path=./prod/dist/ \
 && ng build --environment=test --output-path=./test/dist/ \
 && ng build --environment=dev --output-path=./dev/dist/

FROM nginx:1.11.5
WORKDIR /
ADD startup.sh startup.sh

ENV UI_ENV=prod

COPY --from=webapp /clarity-seed/src/prod/dist /clarity-seed/prod/dist
COPY --from=webapp /clarity-seed/src/test/dist /clarity-seed/test/dist
COPY --from=webapp /clarity-seed/src/dev/dist /clarity-seed/dev/dist

CMD ["./startup.sh"]