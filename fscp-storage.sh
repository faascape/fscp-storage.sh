#! /bin/bash


function usage {
	echo "Usage : fscp-storage.sh COMMAND [STORAGE_TARGET_PATH] [FILENAME_TO_UPLOAD]"
	echo "COMMAND : upload, get, delete, help"
	echo "Environment variables :"
	echo "FSCP_ENDPOINT : example : https://api.amz-eu-west-1.faascape.com (mandatory)"
	echo "FSCP_TOKEN : ABCDEFGHIJ (mandatory)"
	echo "FSCP_PROVIDER : s3/s3, google/google, azure/azure (optional)"
	echo "FSCP_KEY : optional needed if customer want to use his own account"
	echo "FSCP_SECRET : optional needed if customer want to use his own account"
	echo "FSCP_BUCKET : optional needed if customer want to use his own account"
	echo "FSCP_GOOGLE_ID : optional needed if customer want to use his own google account"
}


function buildHeaders {

	HEADERS="-H \"authorization: Bearer $FSCP_TOKEN\""
	    
	if [ "$FSCP_PROVIDER" != "" ]
	then
		HEADERS=$HEADERS" -H \"x-fscp-provider: $FSCP_PROVIDER\""
	fi
	
	if [ "$FSCP_KEY" != "" ]
	then
		HEADERS=$HEADERS" -H \"x-fscp-key: $FSCP_KEY\""
	fi
	
	if [ "$FSCP_SECRET" != "" ]
	then
		HEADERS=$HEADERS" -H \"x-fscp-secret: $FSCP_SECRET\""
	fi
	
	if [ "$FSCP_BUCKET" != "" ]
	then
		HEADERS=$HEADERS" -H \"x-fscp-bucket: $FSCP_BUCKET\""
	fi
	
	if [ "$FSCP_GOOGLE_ID" != "" ]
	then
		HEADERS=$HEADERS" -H \"x-fscp-google-id: $FSCP_GOOGLE_ID\""
	fi
	
}

if [ $# -lt 2 ]
then
	usage
	exit 1
fi

if [ "$FSCP_TOKEN" = "" ]
then
    echo "Variable FSCP_TOKEN must be set"
    exit 2
fi

if [ "$FSCP_ENDPOINT" = "" ]
then
    echo "Variable FSCP_ENDPOINT must be set"
    exit 2
fi



buildHeaders

case $1 in

upload)
if [ $# -ne 3 ]
then
	usage
else
	FILESIZE=$(stat -c%s "$3")
    HEADERS=$HEADERS" -H \"Content-Length: $FILESIZE\""
    eval curl -X POST --data-binary @$3 $HEADERS $FSCP_ENDPOINT/storage/lts/$2
fi
;;

get)
if [ $# -ne 2 ]
then
	usage
else
	eval curl $HEADERS $FSCP_ENDPOINT/storage/lts/$2
fi;;

delete)
if [ $# -ne 2 ]
then
	usage
else
	eval curl -X DELETE $HEADERS $FSCP_ENDPOINT/storage/lts/$2
fi
;;

*)
usage
;;

esac
