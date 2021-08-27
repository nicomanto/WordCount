echo "Waiting for Kafka to come online..."

cub kafka-ready -b kafka:9092 1 20

kafka-topics \
    --create \
    --bootstrap-server kafka:9092 \
    --replication-factor 1 \
    --partitions 1 \
    --topic streams-plaintext-input

kafka-topics \
    --create \
    --bootstrap-server kafka:9092 \
    --replication-factor 1 \
    --partitions 1 \
    --topic streams-wordcount-output

# add data to input topic
echo "Add data to streams-plaintext-input"
kafka-console-producer \
    --bootstrap-server kafka:9092 \
    --topic streams-plaintext-input < data/string-input.txt

# look output topic
echo "Consume data from streams-wordcount-output"
kafka-console-consumer \
    --bootstrap-server kafka:9092 \
    --topic streams-wordcount-output \
    --from-beginning \
    --formatter kafka.tools.DefaultMessageFormatter \
    --property print.key=true \
    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer
