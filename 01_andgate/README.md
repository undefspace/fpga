# 01_andgate
Демонстрация основных возможностей Verilog. Прочитайте код, установите Verilator
(входит в состав OSS CAD Suite), Just и запустите симуляцию:
```sh
git clone https://github.com/undefspace/fpga.git
cd fpga/01_andgate
just verilate
```

В директории должен появиться файл `trace.vcd`, который можно открыть GTKWave
или другим визуализатором сигналов.
