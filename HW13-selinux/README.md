# HomeWork 12: Authentication Authorization Accounting

## Tasks

The main target is ability to diagnose a problems and to fix SELinux policies, when it's necessary to app functioned properly.
1. Run nginx on alternative port using 3 different ways:
   - `setsebool` switch;
   - add an alternative port to existing `type`;
   - develop and install `selinux module`;
Expected result: description of every implementation in README (demos and screenshots are welcome).

2. Ensure that the application works when selinux is enabled
   - deploy attached [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems);
   - find out why the DNS zone refresh functionality isn't working;
   - suggest a solution to the problem;
   - choose one of the solutions, justify the choice of a solution;
   - implement the solution and make a demo
Expected result:
- README with a description of the broken functionality analyse, an available solutions and a justifycation of choosed solution;
- A fixed `test environment` or a demo of the proper DNS zone refresh functionality whth a screenshots and a description.


Цель: Тренируем умение работать с SELinux: диагностировать проблемы и модифицировать политики SELinux для корректной работы приложений, если это требуется.
1. Запустить nginx на нестандартном порту 3-мя разными способами:
- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.
К сдаче:
- README с описанием каждого решения (скриншоты и демонстрация приветствуются).

2. Обеспечить работоспособность приложения при включенном selinux.
- Развернуть приложенный стенд
https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems
- Выяснить причину неработоспособности механизма обновления зоны (см. README);
- Предложить решение (или решения) для данной проблемы;
- Выбрать одно из решений для реализации, предварительно обосновав выбор;
- Реализовать выбранное решение и продемонстрировать его работоспособность.
К сдаче:
- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них;
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.
Критерии оценки:
Обязательно для выполнения:
- 1 балл: для задания 1 описаны, реализованы и продемонстрированы все 3 способа решения;
- 1 балл: для задания 2 описана причина неработоспособности механизма обновления зоны;
- 1 балл: для задания 2 реализован и продемонстрирован один из способов решения;
Опционально для выполнения:
- 1 балл: для задания 2 предложено более одного способа решения;
- 1 балл: для задания 2 обоснованно(!) выбран один из способов решения.

## Documentation

### links

- MUST READ! https://defcon.ru/os-security/1264/
- MUST READ! https://www.nginx.com/blog/using-nginx-plus-with-selinux/
- Nice article about SELinux and Networking: https://wiki.gentoo.org/wiki/SELinux/Networking
- RedHat 7 guide https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-troubleshooting-fixing_problems

### utils

Package `setools-console`:
- `sesearch`
- `seinfo`
- `findcon`
- `getsebool`
- `setsebool`
Package `policycoreutils-python`:
- `audit2allow`
- `audit2why`
Package `policycoreutils-newrole`:
- `newrole`
Package `selinux-policy-mls`:
- `selinux-policy-mls`
Package `setroubleshoot-server`:
- `sealert`

### contexts

Selinux contexts are at `/etc/selinux/targeted/contexts/files`

### Task 1: nginx

[NGINX.md](./NGINX.md)
