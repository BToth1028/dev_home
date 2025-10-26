FROM node:20-bullseye
WORKDIR /workspace
COPY package.json package-lock.json* .npmrc* ./
RUN npm install --silent || npm install --silent --no-fund
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]
