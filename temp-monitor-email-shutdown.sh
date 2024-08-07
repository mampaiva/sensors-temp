#!/bin/bash

# Salvar o PID do processo em um arquivo
echo $$ > /var/run/monitor_temp_log.pid

# Intervalo de tempo entre cada leitura em segundos
INTERVALO=5

# Endereço de email para notificação
EMAIL="mts381@gmail.com"

# Função para obter a temperatura do processador
obter_temperatura() {
    sensors | grep 'Core 0' | awk '{print $3}' | tr -d '+°C'
}

# Função para enviar email
enviar_email() {
    ASSUNTO=$1
    MENSAGEM=$2
 echo -e "Subject: $ASSUNTO\n\n$MENSAGEM" | msmtp -a gmail $EMAIL
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

# Flag para controle de notificação
NOTIFICACAO_ENVIADA=0

# Loop infinito para monitorar a temperatura
while true; do
    TEMP=$(obter_temperatura)
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP $TEMP" >> $ARQUIVO_LOG
    echo "Temperatura do CPU: $TEMP°C"

    if [ $(echo "$TEMP > 60" | bc) -eq 1 ] && [ $NOTIFICACAO_ENVIADA -eq 0 ]; then
        enviar_email "Alerta de Temperatura do CPU" "A temperatura do CPU ultrapassou 60°C. Temperatura atual: $TEMP°C."
        NOTIFICACAO_ENVIADA=1
    fi

    if [ $(echo "$TEMP > 90" | bc) -eq 1 ]; then
        enviar_email "Alerta Crítico de Temperatura do CPU" "A temperatura do CPU ultrapassou 90°C. O sistema será desligado. Temperatura atual: $TEMP°C."
        sudo shutdown -h now
    fi

    sleep $INTERVALO
    rotacionar_log
done

