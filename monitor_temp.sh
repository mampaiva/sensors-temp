#!/bin/bash

# Intervalo de tempo entre cada leitura em segundos
INTERVALO=10

# Função para obter a temperatura do processador
obter_temperatura() {
    sensors | grep 'Core 0' | awk '{print $3}' | head -n 1 | tr -d '+°C.0'
}

# Função para gerar um novo arquivo de log diário
iniciar_novo_log() {
    DATA_ATUAL=$(date +"%Y-%m-%d")
    ARQUIVO_LOG="temperaturas_$DATA_ATUAL.log"
    echo "Iniciando novo log: $ARQUIVO_LOG"
    # Limpa o arquivo de log
    > $ARQUIVO_LOG
}

# Função para rotacionar o log ao final do dia
rotacionar_log() {
    NOVA_DATA=$(date +"%Y-%m-%d")
    if [ "$DATA_ATUAL" != "$NOVA_DATA" ]; then
        mv $ARQUIVO_LOG "temperaturas_$DATA_ATUAL.log"
        iniciar_novo_log
    fi
}

# Inicia o primeiro arquivo de log
iniciar_novo_log

# Loop infinito para monitorar a temperatura
while true; do
    TEMP=$(obter_temperatura)
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP $TEMP" >> $ARQUIVO_LOG
    echo "Temperatura do CPU: $TEMP°C"
    sleep $INTERVALO
    rotacionar_log
done
