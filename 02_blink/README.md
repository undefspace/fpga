# 02_blink
Простая синтезируемая мигалка для платы Tang Nano 9K. Прочитайте код, установите
OSS CAD Suite и Just, прошейте ПЛИС:
```sh
git clone https://github.com/undefspace/fpga.git
cd fpga/02_blink
just upload_to_flash
```

Светодиод должен переключаться со скоростью 2.7 раз в секунду.
