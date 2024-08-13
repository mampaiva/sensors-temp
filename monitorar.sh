#!/bin/bash

# Caminho para o arquivo de log
LOG_FILE="monitoramento.log"

# Função para monitorar a temperatura
monitorar_temperatura() {
    echo "Monitorando Temperatura:" >> $LOG_FILE
    sensors | grep 'Core' >> $LOG_FILE   # Pode ajustar conforme seu hardware
    echo "" >> $LOG_FILE
}

# Função para monitorar o uso da RAM
monitorar_ram() {
    echo "Monitorando Uso de RAM:" >> $LOG_FILE
    free -h | awk '/Mem:/ {print "Memória Usada: " $3 "/" $2}' >> $LOG_FILE
    free -h | awk '/Swap:/ {print "Swap Usada: " $3 "/" $2}' >> $LOG_FILE
    echo "" >> $LOG_FILE
}

# Função para monitorar o uso de disco
monitorar_disco() {
    echo "Monitorando Uso de Disco:" >> $LOG_FILE
    df -h | awk '$NF=="/"{print "Uso do Disco: " $3 " / " $2 " (" $5 " utilizado)"}' >> $LOG_FILE
    echo "" >> $LOG_FILE
}

# Função para monitorar a taxa de leitura e escrita do disco
monitorar_taxa_disco() {
    echo "Monitorando Taxa de Leitura/Escrita do Disco:" >> $LOG_FILE
    iostat -dx | awk 'NR==3 {print "Dispositivo: "$1} NR==4 {print "Leitura/s: " $6 " KB/s, Escrita/s: " $7 " KB/s"}' >> $LOG_FILE
    echo "" >> $LOG_FILE
}

# Loop infinito para monitorar constantemente
while true; do
    echo "Monitoramento em: $(date)" >> $LOG_FILE
    monitorar_temperatura
    monitorar_ram
    monitorar_disco
    monitorar_taxa_disco
    echo "-----------------------------------------" >> $LOG_FILE
    sleep 5  # Tempo de intervalo entre as verificações (em segundos)
done
