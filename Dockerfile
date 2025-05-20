# Build stage
FROM golang:1.22.10-alpine AS builder

# Install necessary build tools
RUN apk add --no-cache gcc musl-dev

WORKDIR /app

# Copy only the go.mod and go.sum files first
COPY go.mod go.sum ./

# Download dependencies (this layer will be cached if the go.mod and go.sum files don't change)
RUN go mod download

# Copy the rest of the source code
COPY . .


# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main cmd/main/main.go

# Final stage
FROM alpine:3.18

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Copy the translations folder into the final image (including translation JSON files)
COPY translations /app/translations

# Copy the aqary.jpeg file into the final image
COPY aqary.jpeg /app/aqary.jpeg

# Expose the port the app runs on
EXPOSE 8080

# Run the binary
CMD ["./main"]