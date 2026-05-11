#!/usr/bin/env bash

set -euo pipefail

IMAGE="basantmandal/hk2-php8.3-fpm:2.1.0"
CONTAINER="php-test-container"

echo "🧹 Cleanup old container..."
docker rm -f $CONTAINER >/dev/null 2>&1 || true

echo "🚀 Starting container..."
docker run -d --name $CONTAINER $IMAGE

# Wait for container to boot
sleep 3

echo "🔍 Running tests..."

fail() {
  echo "❌ TEST FAILED: $1"
  docker logs $CONTAINER
  docker rm -f $CONTAINER >/dev/null 2>&1
  exit 1
}

pass() {
  echo "✅ $1"
}

# -----------------------------
# 1. PHP Version
# -----------------------------
PHP_VERSION=$(docker exec $CONTAINER php -r "echo PHP_VERSION;")
[[ "$PHP_VERSION" == 8.3* ]] || fail "PHP version is not 8.3"
pass "PHP version OK ($PHP_VERSION)"

# -----------------------------
# 2. Required Extensions
# -----------------------------
REQUIRED_EXT=("redis" "intl" "gd" "pdo_mysql" "soap" "zip" "xsl")

for ext in "${REQUIRED_EXT[@]}"; do
  docker exec $CONTAINER php -m | grep -q "^$ext$" || fail "Missing extension: $ext"
done
pass "All required extensions loaded"

# -----------------------------
# 3. Config Validation
# -----------------------------
MEMORY=$(docker exec $CONTAINER php -r "echo ini_get('memory_limit');")
[[ "$MEMORY" == "4096M" ]] || fail "memory_limit incorrect ($MEMORY)"
pass "memory_limit OK"

# -----------------------------
# 4. IonCube Check
# -----------------------------
docker exec $CONTAINER php -m | grep -qi ioncube || fail "IonCube not loaded"
pass "IonCube loaded"

# -----------------------------
# 5. Composer Check
# -----------------------------
docker exec $CONTAINER composer --version | grep -q "^Composer version 2" || fail "Composer v2 missing"
pass "Composer OK"

# -----------------------------
# 6. Permission Check
# -----------------------------
docker exec $CONTAINER bash -c "touch /var/www/html/test.txt" || fail "Permission issue"
pass "Write permission OK"

# -----------------------------
# 7. PHP-FPM Running
# -----------------------------
docker exec $CONTAINER pgrep php-fpm >/dev/null || fail "php-fpm not running"
pass "PHP-FPM running"

# -----------------------------
# DONE
# -----------------------------
echo "🎉 ALL TESTS PASSED"

docker rm -f $CONTAINER >/dev/null 2>&1