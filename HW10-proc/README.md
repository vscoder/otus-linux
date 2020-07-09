# HomeWork 10: proc

## Tasks

Работаем с процессами

Задания на выбор:
1. написать свою реализацию ps ax используя анализ /proc
   - Результат ДЗ - рабочий скрипт который можно запустить
2. написать свою реализацию lsof
   - Результат ДЗ - рабочий скрипт который можно запустить
3. дописать обработчики сигналов в прилагаемом скрипте, оттестировать, приложить сам скрипт, инструкции по использованию
   - Результат ДЗ - рабочий скрипт который можно запустить + инструкция по использованию и лог консоли
4. реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice
   - Результат ДЗ - скрипт запускающий 2 процесса с разными ionice, замеряющий время выполнения и лог консоли
5. реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
   - Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли

Критерии оценки: 5 баллов - принято - любой скрипт
- +1 балл - больше одного скрипта
- +2 балла все скрипты

---

The Linux processes

Tasks to choose:
1. write custom `ps ax` implementation, using `/proc` filesystem analyse
  - the result is runnable script
2. write custom `lsof` implementation
  - the result is runnable script
3. add signals handlers to the script, test the script, add the script and usage instructions
  - the result is runnable script + usage instruction + console's log
4. implement 2 concurrent IO processes and run they with different `ionice`
  - the result is a script which running 2 processes with different `ionice` and log duration and additional info
5. implement 2 concurrent CPU processes and run they with different `nice`
  - the result is a script which running 2 processes with different `nice` and log duration and additional info

## implementation


