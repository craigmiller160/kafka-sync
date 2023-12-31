#!/bin/sh

rm ./producer/database.json 2>/dev/null
rm ./consumer/database.json 2>/dev/null
rm -rf ./docker/kafka/config
rm -rf ./docker/kafka/data