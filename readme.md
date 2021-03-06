# Учебный проект для студентов МЭИ проходящих практику в dsol в 2022 году
- [Описание топ уровня и блоксхема](doc/top/top.md)

## Цели проекта
1. Научиться писать юнит тесты для rtl блоков
2. Познакомиться с шинами межпроцессорного взаимодейстия
3. Научиться собирать простые системы с вычислительным ядром
4. Научиться работать с системой контроля версий
5. Применить полученные знания использовав собранную систему на кристале для рабочей задачи

## Предварительный список задач
### Направление 1. Сборка SCR1 + TB + top-level
1. Собрать топ-уровень с ядром scr1(Для начала с tcm)
2. Сделать тестбенч(tb.sv), в котором подключен топ-уроень.
3. Написать функции загрузки *.bin файла в tcm память из tb.
4. Встроить в топ уровень ahbctrl + apbctrl

### Направление 2. Разработка ВПО
1. Создать проект в eclipse.
2. организация структуры проекта.

### Направление 3. Интерфейсы
1. Написать unit-test блока apbuart(grlib). Встроить блок в топ-уровень. Протестировать в основном tb.
2. Написать unit-test блока spictrl(grlib). Встроить блок в топ-уровень. Протестировать в основном tb.
3. Написать unit-test блока grgpio(grlib). Встроить блок в топ-уровень. Протестировать в основном tb.

## Факультативы. Лекции, которые мы хотели бы, чтобы провели кураторы
1. D-Триггер отличие от латча. Типы сброса(синхронный/асинхронный). Тайминги(Tsetup, Thold, Tclk2out).
2. Клоковые домены. Пересинхронизация сигналов между клоковыми доменами.
 - Пересенихронизация одноразрядного сигнала.(через N триггеров)
 - Пересенихронизация многоразрядного сигнала.(схема с хэндшейком)
 - Асинхронный фифо буфер.
3. Шины межпроцессорных соединений. AMBA(APB, AHB, AXI, AXI-Lite, AXIS).

## Папки в репозитории
- **hard** - verilog и vhdl описание проекта, тестовое окружение
- **soft** - проекты и прошивки для ядра
- **doc** - документация на проект и описание задач, спеки всякие
Структура примерно повторяет ту, что мы используем в рабочих проектах.

## Полезные ссылки
- [Шпаргалка по маркдауну](https://gist.github.com/Jekins/2bf2d0638163f1294637#Links)
