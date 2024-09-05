# 03_variable_blink
Синтезируемая мигалка с изменяемой частотой для платы Tang Nano 9K. Прочитайте
код, установите OSS CAD Suite и Just, прошейте ПЛИС:
```sh
git clone https://github.com/undefspace/fpga.git
cd fpga/03_variable_blink
just upload_to_flash
```

Светодиод должен переключаться со скоростью 2.7 раз в секунду. Нажатие на кнопки
должно приводить к изменению частоты в разные стороны в зависимости от нажатой
кнопки.
