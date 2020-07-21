# Ansible

## Prepare

Create virtual environment and install ansible
```shell
python3 -m venv .venv
source .venv/bin/activate
pip install ansible==2.9.10
```
<details><summary>output</summary>
<p>

```log
Collecting ansible
  Downloading https://files.pythonhosted.org/packages/03/4f/cccab1ec2e0ecb05120184088e00404b38854809cf35aa76889406fbcbad/ansible-2.9.10.tar.gz (14.2MB)
    100% |████████████████████████████████| 14.2MB 137kB/s 
Collecting PyYAML (from ansible)
Collecting cryptography (from ansible)
  Downloading https://files.pythonhosted.org/packages/58/95/f1282ca55649b60afcf617e1e2ca384a2a3e7a5cf91f724cf83c8fbe76a1/cryptography-2.9.2-cp35-abi3-manylinux1_x86_64.whl (2.7MB)
    100% |████████████████████████████████| 2.7MB 586kB/s 
Collecting jinja2 (from ansible)
  Using cached https://files.pythonhosted.org/packages/30/9e/f663a2aa66a09d838042ae1a2c5659828bb9b41ea3a6efa20a20fd92b121/Jinja2-2.11.2-py2.py3-none-any.whl
Collecting cffi!=1.11.3,>=1.8 (from cryptography->ansible)
  Using cached https://files.pythonhosted.org/packages/f1/c7/72abda280893609e1ddfff90f8064568bd8bcb2c1770a9d5bb5edb2d1fea/cffi-1.14.0-cp36-cp36m-manylinux1_x86_64.whl
Collecting six>=1.4.1 (from cryptography->ansible)
  Using cached https://files.pythonhosted.org/packages/ee/ff/48bde5c0f013094d729fe4b0316ba2a24774b3ff1c52d924a8a4cb04078a/six-1.15.0-py2.py3-none-any.whl
Collecting MarkupSafe>=0.23 (from jinja2->ansible)
  Using cached https://files.pythonhosted.org/packages/b2/5f/23e0023be6bb885d00ffbefad2942bc51a620328ee910f64abe5a8d18dd1/MarkupSafe-1.1.1-cp36-cp36m-manylinux1_x86_64.whl
Collecting pycparser (from cffi!=1.11.3,>=1.8->cryptography->ansible)
  Using cached https://files.pythonhosted.org/packages/ae/e7/d9c3a176ca4b02024debf82342dab36efadfc5776f9c8db077e8f6e71821/pycparser-2.20-py2.py3-none-any.whl
Building wheels for collected packages: ansible
  Running setup.py bdist_wheel for ansible ... error
  Complete output from command /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/.venv/bin/python3 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-jwgf2s1a/ansible/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" bdist_wheel -d /tmp/tmpdf_heq14pip-wheel- --python-tag cp36:
  usage: -c [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
     or: -c --help [cmd1 cmd2 ...]
     or: -c --help-commands
     or: -c cmd --help
  
  error: invalid command 'bdist_wheel'
  
  ----------------------------------------
  Failed building wheel for ansible
  Running setup.py clean for ansible
Failed to build ansible
Installing collected packages: PyYAML, pycparser, cffi, six, cryptography, MarkupSafe, jinja2, ansible
  Running setup.py install for ansible ... done
Successfully installed MarkupSafe-1.1.1 PyYAML-5.3.1 ansible-2.9.10 cffi-1.14.0 cryptography-2.9.2 jinja2-2.11.2 pycparser-2.20 six-1.15.0
```
</p>
</details>

Install molecule with vagrant support https://pypi.org/project/molecule-vagrant/
```shell
pip install molecule-vagrant==0.3
```
