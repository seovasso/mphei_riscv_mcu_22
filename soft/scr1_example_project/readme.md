# Тестовый проект программы SCR1

## Инструменты

### Eclipse IDE

Страница с релизом: https://www.eclipse.org/downloads/packages/release/2022-06/r/eclipse-ide-embedded-cc-developers

Прямая ссылка на архив: https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-06/R/eclipse-embedcpp-2022-06-R-win32-x86_64.zip

### GCC RISCV Toolchain (compiler)

Страница: https://github.com/ilg-archived/riscv-none-gcc/releases/tag/v8.1.0-2-20181019

Прямая ссылка на архив: https://github.com/ilg-archived/riscv-none-gcc/releases/download/v8.1.0-2-20181019/gnu-mcu-eclipse-riscv-none-gcc-8.1.0-2-20181019-0952-win64.zip

### Build Tools for Windows (make)

Страница: https://gnu-mcu-eclipse.github.io/windows-build-tools/install/

Ссылка на архив: https://github.com/xpack-dev-tools/windows-build-tools-xpack/releases/download/v4.3.0-1/xpack-windows-build-tools-4.3.0-1-win32-x64.zip

## Сборка проекта

1. Распаковать сам проект, тулчейн и build tools так, чтобы структура папок была следующей:

   ```
   scr1_example_project
          |-- soft
   			|- eclipse
   				 |- compiler
   					   |- GNU MCU Eclipse
   					   |		|- RISC-V Embedded GCC
   					   |					|- 8.1.0-2-20181019-0952
   					   |
   					   |- xpack-windows-build-tools-4.3.0-1
   			      |
   			      |- lib
   			      |   |- hardware
   			      |
   			      |- projects
   			      	    |- scr1_test_project
   ```

   

2. Распаковать Eclipse IDE в любую папку. Его расположение ни на что не влияет

3. Запустить Эклипс (eclipse.exe), согласиться на предложение о расположении workspace (по умолчанию предлагают в C:\Users\)

4. Импортировать проект:

   1. File -> Import -> General -> Existing ... -> Указать папку до уровня soft/eclipse/projects
   2. В списке проектов должен появиться проект scr1_test_project, выбрать его, никакие галочки не трогать, нажать Finish

5. Развернуть дерево проекта в Project Explorer, открыть файл src/main.c

6. Задать конфигурацию Debug активной. Для этого Project -> Build Configurations -> Set Active -> Debug

7. Пересобрать проект. Для этого сделать Clean и затем Build (правой кнопкой по имени проекта в Project Explorer, выбрать Clean Project. Затем повторить, выбрав Build Project). 
   При успешном билде в консоли Эклипса не будет ошибок или предупреждений, последним сообщением будет " Build Finished. 0 errors, 0 warnings."

8. В результате сборки в папке \scr1_example_project\soft\eclipse\projects\scr1_test_project\Debug должны появиться файлы .bin, .elf, .lst, .map