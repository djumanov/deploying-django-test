# Django Framework yordamida todo-app ni AWS ga Deploy Qilish

todo-app nomli loyihasini AWS (Amazon Web Services) bulutiga Docker Compose, Gunicorn va Nginx yordamida qanday o'rnatish haqida ko'rsatadi.

## Technologiya va toollar

- Django
- Django Rest Framework
- Gunicorn
- Nginx
- Docker
- PostgreSQL

## Loyiha Fayl Strukturi

Loyiha asosiy papkasi deploying-django-test ichida quyidagi fayl va papkalarni ko'rish mumkin:

```
deploying-django-test/
│
├── todo/
│   ├── api/
│   │   ├── migrations/
│   │   │   └── ...
│   │   ├── __init__.py
│   │   ├── admin.py
│   │   ├── apps.py
│   │   ├── models.py
│   │   ├── tests.py
│   │   └── views.py
│   │   └── urls.py
│   │
│   ├── core/
│   │   ├── __init__.py
│   │   ├── asgi.py
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   │
│   ├── manage.py
│
├── nginx/
│   ├── default.conf
│   └── Dockerfile
│
├──.gitignore
├──.env
├──.env.example
├── requirements.txt
├── entrypoint.sh
├── Dockerfile
├── docker-compose.yml
```

- **todo/**: Asosiy proyekt kodlari uchun papka.
  - **api/**: Todo-app funksiyalari va loyiha kodlari.
    - **migrations/**: Django o'zgartirishlari uchun migratsiya fayllari.
    - **__init__.py, admin.py, apps.py, models.py, tests.py, views.py, urls.py**: Todo-app kodlari.
  - **core/**: Proyekt asosiy sozlamalari.
    - **__init__.py, asgi.py, settings.py, urls.py, wsgi.py**: Proyekt sozlamalari.
  - **manage.py**: Django proyekti boshqaruvchi skript.
  
- **nginx/**: Nginx server sozlamalari uchun papka.
  - **default.conf**: Nginx server konfiguratsiya fayli.
  - **Dockerfile**: Nginx uchun Dockerfile.

- **.gitignore**: Git chetlab o'tish fayllarni ko'rsatadi.

- **.env, .env.example**: O'zgaruvchilar va konfiquratsiyalar uchun .env fayllari.

- **requirements.txt**: Python paketlarini ro'yxatga olish uchun fayl.

- **entrypoint.sh**: Proyektni boshlash skripti.

- **Dockerfile**: Proyektning Dockerfile-i.

- **docker-compose.yml**: Xizmatlarni (Nginx, PostgreSQL, Django server) Docker Compose uchun konfiguratsiya fayli.

Bu strukturada **todo/** papkasi asosiy proyekt kodlarini (API va asosiy sozlamalar) o'z ichiga oladi, **nginx/** papkasi esa Nginx server sozlamalari uchun ishlatiladi. Barcha fayllar va papkalar loyihani boshqarish va sozlashda yordam beradi.

### **entrypoint.sh**

Bu skript Django ilovasini ishga tushirish uchun kerak bo'lgan oddiy `entrypoint.sh` ning bir misolini taqdim etadi. Bu skript `manage.py` yordamida migratsiyalarni bajaradi, to'plangan static fayllarni olib keladi va Gunicorn serverini ishga tushiradi.

```bash
#!/bin/sh

# Migratsiyalarni amalga oshirish
python manage.py migrate --no-input

# Static fayllarni to'plash
python manage.py collectstatic --no-input

# Gunicorn serverini ishga tushirish
gunicorn core.wsgi:application --bind 0.0.0.0:8000
```

1. **Migratsiyalar**: Skript boshlang'ich ma'lumotlar bazasini yangilaydi. Ammo, hamma narsani o'rnatingizdan so'ng, migratsiyalarni qayta amalga oshirish kerak emas.

2. **Static fayllar**: Bu qadam faqatgina statik fayllarni olib keladi. Real muhitda, CDN (Content Delivery Network) yoki foydalanuvchilarga yuzlabki static fayllarni yuklashni tuzish mumkin.

3. **Gunicorn server**: Ushbu skript `0.0.0.0:8000` portida Gunicorn serverini ishga tushiradi. Real muhitda, nazorat, loglar va qo'llashga ko'maklash uchun boshqacha parametrlarni ham ko'rsatishingiz mumkin.

### **.env.example** ushbu fayl `.env` faylini namunaviy ko'rinishi sifatida ishlaydi va maxfiy ma'lumotlarni o'z ichiga olmaydi.

```plaintext
# Django sozlamalari
DEBUG=True
SECRET_KEY=sizning_maxfiy_kalitingiz
ALLOWED_HOSTS=localhost,127.0.0.1

# Ma'lumotlar bazasining sozlamalari
DB_ENGINE=django.db.backends.postgresql
DB_NAME=sizning_malumotlar_bazangiz_nomi
DB_USER=sizning_malumotlar_bazasi_foydalanuvchisi
DB_PASSWORD=sizning_malumotlar_bazasi_paroli
DB_HOST=db
DB_PORT=5432

# Boshqa sozlamalar
```

Bu fayl `.env` faylini namunaviy ko'rinishi sifatida ishlaydi. Foydalanuvchilar bu fayldan nusxa olib, `.env` faylini o'zgartirib, maxfiy ma'lumotlarni (environment variables) kiritish mumkin bo'ladi.

- **Django sozlamalari**: Bu bo'limda `DEBUG` o'zgaruvchisi loyihaning ish vaqti rejimini sozlaydi. `SECRET_KEY` maxfiy kalitni o'z ichiga oladi, shu bilan loyiha xavfsizligini ta'minlaydi. `ALLOWED_HOSTS` foydalanuvchi tomonidan qabul qilingan hostlarni ro'yxatlash uchun ishlatiladi.

- **Ma'lumotlar bazasining sozlamalari**: Bu bo'limda `DB_ENGINE`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST`, va `DB_PORT` o'zgaruvchanlari PostgreSQL ma'lumotlar bazasi uchun sozlamalarni o'z ichiga oladi.

- **Boshqa sozlamalar**: Bu bo'limda loyiha doirasidagi boshqa muhit o'zgaruvchanlari qo'shilishi mumkin. Bu yerda loyihada qo'llaniladigan boshqa o'zgaruvchanlarni ko'rsatish mumkin.

Yodda tuting, `.gitignore` faylida ham bu `.env` faylini qo'shib bo'lishi kerak, shunda maxfiy ma'lumotlar remote repositoryga yuklanmasligi ta'minlanadi.

