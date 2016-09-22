if [ ! -f "$MOGENERATOR_BIN" ] 
then
	echo "mogenerator binary doesn't exist at $MOGENERATOR_BIN"
	exit 1
fi

echo "Generating Data Model Classes from $DATA_MODEL_FILE ..."
if [ ! -d "$DATA_MODEL_FILE" ] 
	then
	echo "Data model file doesn't exist at $DATA_MODEL_FILE"
exit 1
fi

mkdir -p "$DATA_MODEL_SOURCE_DIR"

MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS=YES \
MOMC_SUPPRESS_INVERSE_TRANSIENT_ERROR=YES \
"$MOGENERATOR_BIN" \
-m "$DATA_MODEL_FILE" \
--base-class "$BASE_CLASS" \
--includeh "$AGGREGATE_HEADER" \
--template-path "$MOGENERATOR_TEMPLATES" \
-O "$DATA_MODEL_SOURCE_DIR" || exit 1

echo "Generated Data Model Classes to $DATA_MODEL_SOURCE_DIR"
