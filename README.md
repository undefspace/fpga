# Материалы ПЛИСальной
ПЛИСальная - регулярное мероприятие в [undef.space](https://undef.club), на
котором мы тыкаем язык Verilog и Программируемые Логические Интегральные Схемы
(ПЛИС).

## Инструменты

### Железо
В качестве целевого оборудования используется плата 
[Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html)
на базе FPGA `Gowin GW1NR-9`.

### Софт
Установите [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build) -
среди прочего он содержит:
  - Симулятор Verilator
  - Синтезатор Yosys+NextPnR+Apicula
  - Программатор openFPGALoader
  - Визуализатор файлов с сигналами GTKWave

Рекомендуется установить:
  - Расширение с поддержкой языка Verilog для Вашего редактора
  - Систему сборки Just - готовые примеры будут использовать её

## Ресурсы
  - [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) - коллекция
    инструментов для симуляции и синтеза
  - [Verilator](https://verilator.org/) - симулятор Verilog
  - [Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html) -
    отладочная плата на базе GW1NR-9
  - [PulseView](https://sigrok.org/wiki/PulseView) - просмотрщик файлов сигналов
  - [Ben Eater](https://www.youtube.com/@BenEater) очень хорошо объясняет
    принципы работы логических схем
  - [netlistsvg](https://github.com/nturley/netlistsvg) - преобразователь
    netlist-ов в изображения в формате SVG
