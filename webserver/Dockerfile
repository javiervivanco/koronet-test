# Stage 1: Builder
FROM python:3.9-alpine as builder
WORKDIR /app

# Install necessary build dependencies
RUN  apk add -u  gcc musl-dev postgresql-dev postgresql-libs scons patchelf && \
    pip install pyinstaller staticx

# Copy application files
COPY . .

# Install Python dependencies
RUN pip install --user -r requirements.txt

# Build the application using PyInstaller
RUN pyinstaller --onefile -d bootloader -w -F --add-data "templates:templates" web-server.py

# Create a statically linked executable using staticx
RUN staticx dist/web-server  dist/web-server-full

# Create a temporary directory
RUN mkdir tmp

# Stage 2: Final image, size 17mb
FROM scratch

# Set working directory
WORKDIR /app

# Copy the statically linked executable from the builder stage
COPY --from=builder /app/dist/web-server-full /app/

# Copy the temporary directory from the builder stage, hack!
COPY --from=builder tmp /tmp

# Set the entrypoint to run the application
ENTRYPOINT ["/app/web-server-full"]