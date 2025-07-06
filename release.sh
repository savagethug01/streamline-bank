#!/bin/sh
set -e

echo "🔄 Running Django migrations..."
python manage.py migrate --noinput
echo "✅ Migrations complete."

echo "📦 Collecting static files..."
python manage.py collectstatic --noinput
echo "✅ Static files collected."
