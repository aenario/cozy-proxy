FROM dockerfile/nodejs

ADD . /opt/app
RUN cd /opt/app && npm install --production

EXPOSE 9104
CMD cd /opt/app && npm start