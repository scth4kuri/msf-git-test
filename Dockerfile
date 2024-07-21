# Use a base image with a suitable operating system
FROM kalilinux/kali-rolling

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    libpq-dev \
    libpcap-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libffi-dev \
    python3 \
    python3-pip \
    ruby \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/*


# Install Metasploit Framework with retry mechanism
RUN for i in 1 2 3; do \
        git clone https://github.com/rapid7/metasploit-framework.git /opt/metasploit-framework && break || sleep 5; \
    done

WORKDIR /opt/metasploit-framework

# Install bundler and bundle install with retry mechanism
RUN gem install bundler && for i in 1 2 3; do \
    bundle install && break || sleep 5; \
    done

# Set environment variables
ENV MSF_DATABASE_CONFIG=/etc/metasploit/database.yml

# Expose Metasploit's default port
EXPOSE 4444

# Set the working directory
WORKDIR /opt/metasploit-framework

# Increase Git buffer size
RUN git config --global http.postBuffer 524288000

# Command to run Metasploit
CMD ["./msfconsole"]