#!/bin/bash

# Replace with your actual API Gateway URL after deployment
API="https://YOUR-API-URL.execute-api.us-east-1.amazonaws.com/dev/users"

echo "==============================="
echo "TEST 1: CREATE USER (POST)"
echo "==============================="
curl -s -X POST $API \
  -H "Content-Type: application/json" \
  -d '{"id":"u001","name":"Alice Johnson","email":"alice@example.com","info":"Cloud Engineer"}' \
  | python3 -m json.tool

echo ""
echo "==============================="
echo "TEST 2: READ USER (GET)"
echo "==============================="
curl -s "$API?id=u001" | python3 -m json.tool

echo ""
echo "==============================="
echo "TEST 3: UPDATE USER (PUT)"
echo "==============================="
curl -s -X PUT $API \
  -H "Content-Type: application/json" \
  -d '{"id":"u001","name":"Alice Johnson","info":"Senior Cloud Engineer"}' \
  | python3 -m json.tool

echo ""
echo "==============================="
echo "TEST 4: VERIFY UPDATE (GET)"
echo "==============================="
curl -s "$API?id=u001" | python3 -m json.tool

echo ""
echo "==============================="
echo "TEST 5: DELETE USER (DELETE)"
echo "==============================="
curl -s -X DELETE "$API?id=u001" | python3 -m json.tool

echo ""
echo "==============================="
echo "TEST 6: VERIFY DELETION (GET)"
echo "==============================="
curl -s "$API?id=u001" | python3 -m json.tool

echo ""
echo "==============================="
echo "TEST 7: ERROR HANDLING (POST without id)"
echo "==============================="
curl -s -X POST $API \
  -H "Content-Type: application/json" \
  -d '{"name":"No ID here"}' \
  | python3 -m json.tool
