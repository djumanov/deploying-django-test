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
