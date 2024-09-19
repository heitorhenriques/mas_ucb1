# Use an OpenJDK image with Java 17
FROM openjdk:17-jdk-alpine
ENV PATH=$PATH:$JAVA_HOME/bin

RUN apk add --update --no-cache git bash fontconfig ttf-dejavu \
    libxrender libxtst libxi wget

# Install Gradle
ARG GRADLE_VERSION=7.5.1
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
ENV PATH=$GRADLE_HOME/bin:$PATH

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

EXPOSE 3271
EXPOSE 3272
EXPOSE 3273

# Run Gradle build
CMD ["gradle", "run"]
