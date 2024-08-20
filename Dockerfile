# Use the official Rust image as a base
FROM rust:1.72 AS builder

# Set the working directory
WORKDIR /app

# Install musl-tools to build statically linked binaries
RUN apt-get update && apt-get install -y musl-tools

# Set the Rust target to musl
RUN rustup target add x86_64-unknown-linux-musl

# Copy the project files into the Docker container
COPY . .

# Build the Rust project for release with musl target
RUN cargo build --release --target x86_64-unknown-linux-musl

# Use a minimal base image for the final container
FROM debian:buster-slim

# Set the working directory
WORKDIR /app

# Copy the compiled binary from the builder image
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/rust-web-server .

# Expose port 3030 to the outside world
EXPOSE 3030

# Run the binary
CMD ["./rust-web-server"]
