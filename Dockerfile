FROM kalilinux/kali-rolling

# Install SSH, tools, and fail2ban (bonus enhancement)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openssh-server sudo \
      nmap metasploit-framework hydra sqlmap john nikto \
      net-tools iproute2 fail2ban && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash kaliuser && \
    echo "kaliuser:kali" | chpasswd && \
    adduser kaliuser sudo

# Set up root password if needed
RUN echo 'root:SuperSecureRoot!' | chpasswd

# Configure SSH access
RUN mkdir -p /var/run/sshd /root/.ssh /home/kaliuser/.ssh && \
    chmod 700 /root/.ssh /home/kaliuser/.ssh

COPY authorized_keys /root/.ssh/authorized_keys
COPY authorized_keys /home/kaliuser/.ssh/authorized_keys

RUN chmod 600 /root/.ssh/authorized_keys /home/kaliuser/.ssh/authorized_keys && \
    chown kaliuser:kaliuser /home/kaliuser/.ssh -R

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin without-password/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Simple fail2ban config for SSH
RUN echo "[sshd]\nenabled = true\nport = 22\nfilter = sshd\naction = iptables[name=SSH, port=22, protocol=tcp]\nlogpath = /var/log/auth.log\nmaxretry = 3\n" > /etc/fail2ban/jail.local

# Workspace setup
RUN mkdir -p /home/kaliuser/workspace && \
    chown kaliuser:kaliuser /home/kaliuser/workspace

EXPOSE 22
CMD ["bash", "-lc", "service fail2ban start && /usr/sbin/sshd -D"]
