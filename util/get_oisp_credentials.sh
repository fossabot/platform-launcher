#!/bin/bash
export SYSTEMUSER_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.mqtt-gateway  | jq -r .frontendSystemPassword)
export GRAFANA_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.grafana | jq -r .adminPassword)
export MQTT_BROKER_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.mqtt-gateway | jq -r .mqttBrokerPassword)
export RULEENGINE_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.rule-engine | jq -r .password)
export RULEENGINE_GEARPUMP_PASSWORD=$( kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.rule-engine | jq -r .gearpumpPassword)
export WEBSOCKETSERVER_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.websocket-user | jq -r .password)
export POSTGRES_SU_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.postgres | jq -r .su_password)
export POSTGRES_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.postgres | jq -r .password)
export KEYCLOAK_PASSWORD=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.keycloak-admin | jq -r .password)
export KEYCLOAK_FRONTEND_SECRET=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.keycloak-frontend-secret)
export KEYCLOAK_MQTT_BROKER_SECRET=$(kubectl -n ${NAMESPACE} get -o yaml configmaps oisp-config | shyaml get-value data.keycloak-mqtt-broker-secret)
export KEYCLOAK_FUSION_BACKEND_SECRET=$(kubectl -n ${NAMESPACE} get -o yaml configmaps fusion-config | shyaml get-value data.keycloak | jq -r .credentials.secret)
# When adding a new secret, it must be created randomly.
# Add this snippet if you add a new secret to the platform.
if [[ "$KEYCLOAK_MQTT_BROKER_SECRET" == "null" ]] || [[ -z "$KEYCLOAK_MQTT_BROKER_SECRET" ]]; then
    echo "Keycloak mqtt broker secret is not present! Randomly creating new one!"
    export KEYCLOAK_MQTT_BROKER_SECRET=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c ${1:-64})
fi
if [[ "$KEYCLOAK_FUSION_BACKEND_SECRET" == "null" ]] || [[ -z "$KEYCLOAK_FUSION_BACKEND_SECRET" ]]; then
    echo "Keycloak fusion backend secret is not present! Randomly creating new one!"
    export KEYCLOAK_FUSION_BACKEND_SECRET=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c ${1:-64})
fi

# Check whether SYSTEMUSER_PASSWORD is recovered to make sure the tools are installed
# and the namespace is valid
if [ -z $SYSTEMUSER_PASSWORD ]
then
    echo "Could not get credentials in namespace: ${NAMESPACE}. Make sure jq and shyaml are installed."
    exit 1
fi
