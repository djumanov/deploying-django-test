#!/bin/sh

# Migratsiyalarni amalga oshirish
python manage.py migrate --no-input

# Static fayllarni to'plash
python manage.py collectstatic --no-input

# Gunicorn serverini ishga tushirish
gunicorn core.wsgi:application --bind 0.0.0.0:8000
