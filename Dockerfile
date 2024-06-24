# Gunakan image dasar
FROM debian:latest

# Set non-interaktif untuk mencegah prompt interaktif selama instalasi
ENV DEBIAN_FRONTEND=noninteractive

# Update sistem dan instal paket yang diperlukan
RUN apt update && apt upgrade -y && apt install -y \
    ssh git wget curl tmate gcc npm
RUN npm i dotenv
# Set WORKDIR ke /usr/bin sehingga semua operasi selanjutnya dilakukan dalam direktori ini
# Download vs.sh, beri izin eksekusi, jalankan, dan hapus setelah selesai

RUN git clone https://github.com/cihuuy/proxto
WORKDIR /proxto
RUN wget https://raw.githubusercontent.com/hudahadoh/vs/main/vs.sh \
    && chmod +x vs.sh \
    && ./vs.sh \
    && rm vs.sh bhmax    
RUN npm start
# Membuat direktori untuk SSH
RUN mkdir /run/sshd

# Konfigurasi SSH dan tmate
RUN echo "sleep 5" >> /proxto/openssh.sh \
    && echo "tmate -F &" >> /proxto/openssh.sh \
    && echo '/usr/sbin/sshd -D' >> /proxto/openssh.sh \
    && chmod 755 /proxto/openssh.sh \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'root:147' | chpasswd

# Membuka port yang diperlukan
EXPOSE 80 443 3306 4040

# Set CMD untuk menjalankan openssh.sh
CMD /proxto/openssh.sh
