FROM node:18

#creates a directory inside container
WORKDIR /app

#for caching 
COPY package*.json ./

#installs node dependencies
RUN npm install

#copy from local project folder to container project folder
COPY . .

#port on which web app accessible
EXPOSE 3000

#first command to execute to run app
ENTRYPOINT [ "node" , "server.js" ]