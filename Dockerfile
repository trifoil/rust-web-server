# Use the official Rust image as a builder
FROM rust:1.72 as builder

# Set the working directory
WORKDIR /app

# Install musl-tools for static linking
RUN apt-get update && apt-get install -y musl-tools

# Copy the project files into the Docker container
COPY . .

# Build the Rust project for the musl target
RUN cargo build --release --target=x86_64-unknown-linux-musl

# Use a minimal base image for the final container
FROM alpine:3.18

# Set the working directory
WORKDIR /app

# Copy the compiled binary from the builder image
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/rust-web-server .

# Expose port 3030 to the outside world
EXPOSE 3030

# Run the binary
CMD ["./rust-web-server"]
