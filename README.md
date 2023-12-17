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

### **.env.example** 

ushbu fayl `.env` faylini namunaviy ko'rinishi sifatida ishlaydi va maxfiy ma'lumotlarni o'z ichiga olmaydi.

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

### **requirements.txt** 

Bu fayl, loyiha ishga tushirilish uchun kerak bo'lgan Python paketlarini ro'yxat qilish uchun ishlatiladi. Faylning maqsadi, loyiha ishga tushirilganda, Python interpreterining kerakli paketlarni avtomatik ravishda o'rnatishini ta'minlashdir.

djangoni o'rnatish

```bash
pip install django==5.0
```

djangorestframeworkni o'rnatish

```bash
pip install djangorestframework==3.14.0
```

gunicornni o'rnatish

```bash
pip install gunicorn==21.2.0
```

O'rnatilgan barcha paketlarni requirements.txt faylga yozish

```bash
pip freeze > requirements.txt
```

Bu yerda:

- `django==5.0`: Django frameworkning ma'lum bir versiyasi. `==` belgisi orqali aniqlangan versiya ko'rinishi bo'lib, `5.0` - bu esa ma'lum bir versiya.
- `djangorestframework==3.14.0`: Django Rest Framework paketi va uning ma'lum bir versiyasi.
- `gunicorn==21.2.0`: Gunicorn serverining ma'lum bir versiyasi.

Bu paketlar loyihada qo'llaniladigan kerakli paketlardir. `requirements.txt` fayli bu paketlarni loyiha yuklab olish uchun `pip` yordamida o'rnatishga yordam beradi. Misol uchun, quyidagi ko'rinishda buyruqni bajaring:

```bash
pip install -r requirements.txt
```

Bu buyruq avtomatik ravishda barcha `requirements.txt` faylida ko'rsatilgan paketlarni o'rnatadi.

### Dockerfile

Bu `Dockerfile` ko'rinishi konteyner yaratish uchun kerakli operatsion tizimni (Alpine) asosida Python 3.10-ni ishga tushiradi va loyihadagi kerakli dasturlarni yuklab olish uchun foydalaniladi.

```Dockerfile
FROM python:3.10-alpine

RUN pip install --upgrade pip

COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY ./todo /app

WORKDIR /app

COPY ./entrypoint.sh /
ENTRYPOINT ["sh", "/entrypoint.sh"]
```

Bu `Dockerfile` fayli, bir Docker konteynerini yaratish uchun berilgan yo'l, dasturlarni o'rnatish va ishga tushirish uchun kerakli buyruqlarni o'z ichiga oladi.

1. **FROM python:3.10-alpine**: Bu qismimiz Docker konteynerini qanday asoslashni aytadi. `python:3.10-alpine` asosiy Python 3.10-ni ishlatadi va Alpine Linux operatsion tizimida yaratiladi. Alpine Linux keng tarqalgan va yengil, ammo o'lchamlari kichik.

2. **RUN pip install --upgrade pip**: Konteyner ishga tushirilganda, bu buyruq `pip`ni yangilaydi, agar talab qilinadigan yangi versiya mavjud bo'lsa.

3. **COPY ./requirements.txt .**: Loyiha folderdagi `requirements.txt` faylini konteynerga ko'chirib oladi. Bu faylda loyihada kerakli Python paketlarining ro'yxati joylashgan.

4. **RUN pip install -r requirements.txt**: Konteyner ichidagi `requirements.txt` fayli orqali Python paketlarini o'rnatadi. `pip install -r` buyrug'i fayl ichidagi barcha paketlarni o'rnatadi.

5. **COPY ./todo /app**: Loyiha katalogidagi `todo` papkasini konteynerga ko'chirib oladi. Bu qism, loyiha kodlarini (Django ilovasi va boshqa fayllar) `app` papkasiga ko'chiradi.

6. **WORKDIR /app**: Konteynerda ishga tushirilganda ish qilish uchun ish folderini (`/app`) sozlash. Barcha keyingi buyruqlar bu katalog ichida bajariladi.

7. **COPY ./entrypoint.sh /**: `entrypoint.sh` skriptini konteynerga ko'chiradi. Bu skript konteyner ishga tushirilganda avtomatik ravishda ishga tushiriladi.

8. **ENTRYPOINT ["sh", "/entrypoint.sh"]**: Konteyner ishga tushirilganda `entrypoint.sh` skriptini ishga tushiradi. Bu skript konteynerning boshlanish jarayonida ishga tushiriladi.

Bu `Dockerfile` asosiy qadamlarni o'z ichiga oladi va loyiha ishga tushirilganda kerakli dasturlarni, konfiguratsiyalarni yuklab, o'rnatib, konteyner ishga tushirilishi uchun tayyor bo'lishini ta'minlaydi.

### **docker-compose.yml**

`docker-compose.yml` fayli, Docker konteynerlarini birlashtirib, ishga tushirish va ularga konfiguratsiya berish uchun foydalaniladi. Bu fayl, bir nechta konteynerlarni bitta loyiha ichida ishga tushirish, ularning interfeyslarini sozlash, ular orasidagi aloqani amalga oshirish va boshqa sozlamalarni belgilash imkonini beradi.

```yaml
version: '3.7'

services:
  todo_server:
    volumes:
    - ./todo:/app
    - ./static:/static
    env_file:
      - .env
    ports:
      - "8000:8000"
    build:
      context: .
    depends_on:
      - db

  db:
    image: postgres:latest
    environment:
      - POSTGRES_DB=dbname
      - POSTGRES_USER=dbuser
      - POSTGRES_PASSWORD=dbpass

volumes:
    static:
```

- `version`: Fayl formatining versiyasini ko'rsatadi.
- `services`: Bu blokda, konteyner xizmatlarini (services) belgilaymiz.
- `todo_server` va `db`: Xizmat nomlari, har birining xususiyatlari ko'rsatiladi.
  - `image`: Konteyner yaratish uchun kerakli rasmdagi ismni belgilaydi (bu rasmlar ko'nguljon tasvirlangan konteyner yaratish imkoniyatini ta'minlashda foydalaniladi).
  - `ports`: Konteyner va hostning portlarini bog'lash uchun ishlatiladi.
  - `volumes`: Fayl ko'chirish uchun kerakli direktoriyalarni belgilaydi.
  - `environment`: Konteynerning muhit o'zgaruvchanlarini o'rnating.
  - `depends_on`: Xizmatning boshqa xizmatlarga bog'liqligini ko'rsatadi.

"Docker Compose" faylni ishga tushirish uchun, Terminal (yoki Command Prompt) dasturida loyihangiz katalogiga o'tib, quyidagi buyruqni ishga tushirishingiz mumkin:

```bash
docker-compose up -d
```

- **`docker-compose`**: Docker Compose dasturini boshlash.
- **`up`**: Barcha xizmatlarni ishga tushiradi va ularga bog'liq konteynerlarni yaratadi yoki ishga tushiradi.
- **`-d`**: Konteynerlarni fonda ishga tushirish (detach mode), bu xizmatlar fonda ishlaydi va terminalni bloklamaydi.

### **nginx/default.conf**

Bu `nginx/default.conf` fayli, Nginx serverining konfiguratsiya fayli hisoblanadi. Bu faylda Django ilovasini ishga tushirgan Docker konteyneri bilan bog'langan joylarni ko'rsatish uchun kerakli sozlamalar joylashadi.

```plaintext
upstream django {
    server todo_server:8000;
}

server {
    listen 80;

    location / {
        proxy_pass: http://django;
    }

    location /static/ {
        alias /static/;
    }
}
```

- `upstream` direktivasi, `django` nomli serveri (`todo_server:8000`) aylanadi. Bu nom asosida Nginx, `todo_server` nomli Django ilovasi bilan bog'langan xizmatning portini (`8000`) aniqlaydi.

- `server` bloki Nginx serverining konfiguratsiyasini boshlaydi.
  - `listen 80;` Nginx serverining 80-portini eshitishni anglatadi, bu oddiy HTTP so'rovlarini qabul qilish uchun ishlatiladi.
  - `location /` direktivasi HTTP so'rovlarini qayerga yo'nlash kerakligini aytadi.
    - `proxy_pass http://django;` HTTP so'rovlarini `django` serveriga yo'nlash uchun ishlatiladi, `upstream` direktivasida aylanib borilgan `todo_server:8000` ga o'xshaydi.
  - `location /static/` direktivasi esa statik fayllarni qayerda topish kerakligini aniqlaydi.
    - `alias /static/;` Statik fayllarni serverning `/static/` yo'lininga joylashtirish uchun ishlatiladi.

Bu konfiguratsiya fayli, Nginx serverini ishga tushirishda Django ilovasi bilan bog'liq so'rovlar uchun yo'l yo'riqnomasi ta'minlaydi va statik fayllarni `todo_server` konteyneriga qanday yuborishini ko'rsatadi.

### **nginx/Dockerfile**

Bu `nginx/Dockerfile` fayli, Nginx serverining Docker konteynerini tuzish uchun foydalaniladi.  Bu faylda Nginx ning Docker obrazini (`nginx:1.19.0-alpine`) o'z ichiga oladi va kerakli konfiguratsiya faylini (`default.conf`) Nginx serverining konfiguratsiya papkasiga ko'chiradi.

```docker
FROM nginx:1.19.0-alpine

COPY ./default.conf /etc/nginx/conf.d/default.conf
```

- `FROM nginx:1.19.0-alpine`: Bu qator, sizning Nginx serverining yangi Docker obrazini `nginx:1.19.0-alpine` asosida yaratish uchun boshlang'ich nuqtani belgilaydi. `alpine` versiyasi esa, kichik hajmli va oddiy operatsion tizimini (Alpine Linux) ko'rsatadi.
  
- `COPY ./default.conf /etc/nginx/conf.d/default.conf`: Bu qator esa, `default.conf` faylini Docker obraziga ko'chirib, uni Nginx serverining konfiguratsiya papkasiga (`/etc/nginx/conf.d/`) joylashadi.

Bu Dockerfile, Nginx serverining konfiguratsiya faylini `nginx:1.19.0-alpine` asosida yaratilgan Docker obraziga joylash uchun ishlatiladi. `default.conf` fayli Nginx serverining sozlamalarini konfiguratsiya qiladi.

### nginx ni docker compose ga qo'shish

```yml
version: '3.7'

services:
  db:
    image: postgres:latest
    environment:
      - POSTGRES_DB=dbname
      - POSTGRES_USER=dbuser
      - POSTGRES_PASSWORD=dbpass

  todo_server:
    volumes:
    - ./todo:/app
    - ./static:/static
    env_file:
      - .env
    ports:
      - "8000:8000"
    build:
      context: .
    depends_on:
      - db

  nginx:
    build: ./nginx
    volumes:
      - ./static:/static
    ports:
      - "80:80"
    depends_on:
      - todo_server  

volumes:
    static:
```

- nginx server

  - `build: ./nginx`: Bu qism `nginx` xizmatining Dockerfile'ini topish uchun qaysi papkada (`./nginx`) qurish kerakligini bildiradi.

  - `volumes: - ./static:/static`: `nginx` xizmatiga statik fayllarni joylashtirish uchun direktivani belgilaydi. Bu joylashtirilgan papka host kompyuterda (`./static`) va konteynerda (`/static`) bir xil yo'lga ega bo'ladi.

  - `ports: - "80:80"`: Ushbu qism Nginx serverining portlarini bog'lash uchun ishlatiladi. `80` portini host kompyuterda (`80`) va konteynerda (`80`) bog'laydi.

  - `depends_on: - todo_server`: Nginx xizmati boshqa xizmatlarga (`todo_server`) bog'lanadi. Bu, `todo_server` xizmatining ishga tushirilishidan oldin Nginx serverining ishga tushirilishini ta'minlaydi.

Bu `docker-compose.yml` faylda `nginx` xizmati qo'shildi. Bu xizmat Nginx serverining konteynerini ishga tushirish va statik fayllarni (`./static`) yo'llash uchun kerakli sozlamalarni o'z ichiga oladi.

### run docker-compose.yml

Docker Compose faylini ishga tushirish uchun, quyidagi komandani Terminal yoki Command Prompt dasturida ishga tushiring:

```bash
docker-compose up -d
```

Bu komanda sizning loyihangizdagi barcha xizmatlarni (`db`, `todo_server`, `nginx`) birlashtirib, ularning ishga tushirilishini boshlaydi. Ular o'rnasiga bog'liq Docker obrazlarini yaratadi, xizmatlar o'rnasiga konteynerlar yaratadi va ularni ishga tushiradi.

Agar siz `docker-compose.yml` fayl ichidagi xizmatlardan faqatgina ma'lum birini ishga tushirishni istasangiz, undan foydalanishingiz mumkin. Masalan:

```bash
docker-compose up todo_server
```

Bu komanda faqatgina `todo_server` xizmatini ishga tushiradi. Bu usul bilan siz o'zingizga kerakli bo'lgan xizmatlarni tanlash va ularni ishga tushirish uchun komandalarni yozishingiz mumkin.
