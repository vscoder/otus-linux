# Task 2: selinux dns problems

## The Task

Ensure that the application works when selinux is enabled
   - deploy attached [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems);
   - find out why the DNS zone refresh functionality isn't working;
   - suggest a solution to the problem;
   - choose one of the solutions, justify the choice of a solution;
   - implement the solution and make a demo
Expected result:
- README with a description of the broken functionality analyse, an available solutions and a justifycation of choosed solution;
- A fixed `test environment` or a demo of the proper DNS zone refresh functionality whth a screenshots and a description.

## Environment

1. Copy [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems) to `./selinux_dns_problems`
2. Up environment
   ```shell
   cd ./selinux_dns_problems
   vagrant up
   ```
3. List hosts
   ```shell
   vagrant status
   ```
   ```log
   Current machine states:

   ns01                      running (virtualbox)
   client                    running (virtualbox)
   ```

## Ensure problem exists


