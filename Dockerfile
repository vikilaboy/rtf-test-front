FROM node:10.16.3 AS builder

# Make the 'app' folder the current working directory
WORKDIR /var/www

# Set PATH variable to node_modules folder
ENV PATH /var/www/node_modules/.bin:$PATH

# Copy both 'package.json' and 'yarn.lock' (if available)
COPY . /var/www

RUN npm install
# Install project dependencies
RUN npm run-script build

# Copy project files and folders to the current working directory (i.e. 'app' folder)
#COPY . /var/www

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

#RUN npm run -script build

FROM nginx:1.17.4 AS one-front

WORKDIR /var/www

COPY --from=builder /var/www /var/www/
COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
