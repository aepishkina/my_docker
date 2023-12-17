#выбор базового образа
FROM alpine:latest
#обновление кеша
RUN apk update \
	#обновление всех пакетов в контейнере
    && apk upgrade \
    # установка nginx (сразу без кеша), по идее, --no-cache должен скачивать без кэша (в директории /var/cache/apk не должно ничего появиться), но можно и без --no-cache, но тогда после apk add использовать команду rm -vrf /var/cache/apk/*
    && apk add nginx \
    #очистить кеш
	&& rm -vrf /var/cache/apk/* \
    #удалить содержимое директории
    && rm -vrf /var/www/*
#создать в директории директорию с именем сайта и папку с картинками \
#поместить в директорию index.html и какртинку
COPY index.html /var/www/my_project/
COPY img.jpg /var/www/my_project/img/
RUN adduser -D -g 'www' www \
    && chown -R www:www /var/lib/nginx \
    && chown -R www:www /var/www
RUN CONF_PATH=$(grep -r "user nginx;" ./etc/nginx | grep -o "^[^:]*") \
    && rm $CONF_PATH
COPY nginx.conf /etc/nginx
#показываем, на каком порту должно работать приложение (после запуска контейнера)
EXPOSE 80
#RUN nginx -t
#запуск веб-сервера в контейнере
CMD ["nginx","-g","daemon off;"]