FROM node:lts-buster

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    imagemagick \
    libwebp-dev && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Optional: Fix ImageMagick security policy restrictions for PDF/SVG if needed
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml || true && \
    sed -i 's/rights="none" pattern="SVG"/rights="read|write" pattern="SVG"/' /etc/ImageMagick-6/policy.xml || true

WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package.json package-lock.json* ./
RUN npm install && npm install -g qrcode-terminal pm2

# Copy rest of the app
COPY . .

EXPOSE 5000

CMD ["npm", "start"]
