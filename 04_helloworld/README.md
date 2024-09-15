# 04_helloworld
Синтезируемый передатчик `Hello, World!` по UART для платы Tang Nano 9K.
Прочитайте код, установите OSS CAD Suite и Just, прошейте ПЛИС:
```sh
git clone https://github.com/undefspace/fpga.git
cd fpga/04_helloworld
just upload_to_flash
```

Нажмите на кнопку, изучите сигнал на 37 пине логическим анализатором. Если
хотите подключиться к встроенному USB-UART конвертеру, поменяйте пин в
`.cst`-файле на 17.
