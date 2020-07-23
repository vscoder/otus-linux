# Ansible

## Prepare

Create virtual environment and install ansible with requirements
```shell
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```
<details><summary>output</summary>
<p>

```log
Collecting ansible==2.9.10 (from -r requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/03/4f/cccab1ec2e0ecb05120184088e00404b38854809cf35aa76889406fbcbad/ansible-2.9.10.tar.gz
Collecting molecule[docker]==3.0.5 (from -r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/06/31/84ea44bdc5bce97e81d22a5c3d70d4ab81b699567c36ba5799017aad5807/molecule-3.0.5-py2.py3-none-any.whl
Collecting testinfra==5.2.2 (from -r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/6e/4b/20a592c7d2f1880aedd140862f749ad69549eb5d6e62a03e8146124d5260/testinfra-5.2.2-py3-none-any.whl
Collecting PyYAML (from ansible==2.9.10->-r requirements.txt (line 1))
Collecting cryptography (from ansible==2.9.10->-r requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/26/d6/e8b087b9ae062d737c67c3bf76e30333bda9295ca17205062e8ed2c872de/cryptography-3.0-cp35-abi3-manylinux1_x86_64.whl
Collecting jinja2 (from ansible==2.9.10->-r requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/30/9e/f663a2aa66a09d838042ae1a2c5659828bb9b41ea3a6efa20a20fd92b121/Jinja2-2.11.2-py2.py3-none-any.whl
Collecting click-completion>=0.5.1 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz
Collecting pluggy<1.0,>=0.7.1 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/a0/28/85c7aa31b80d150b772fbe4a229487bc6644da9ccb7e427dd8cc60cb8a62/pluggy-0.13.1-py2.py3-none-any.whl
Collecting selinux; sys_platform == "linux" (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/65/11/67955ff6fbd5aedee3b4d47847c24510e7de970aa352cacac8444ef33059/selinux-0.2.1-py2.py3-none-any.whl
Collecting click>=7.0 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/d2/3d/fa76db83bf75c4f8d338c2fd15c8d33fdd7ad23a9b5e57eb6c5de26b430e/click-7.1.2-py2.py3-none-any.whl
Collecting tabulate>=0.8.4 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/c4/f4/770ae9385990f5a19a91431163d262182d3203662ea2b5739d0fcfc080f1/tabulate-0.8.7-py3-none-any.whl
Collecting tree-format>=0.1.2 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/0d/91/8d860c75c3e70e6bbec7b898b5f753bf5da404be9296e245034360759645/tree-format-0.1.2.tar.gz
Collecting colorama>=0.3.9 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/c9/dc/45cdef1b4d119eb96316b3117e6d5708a08029992b2fee2c143c7a0a5cc5/colorama-0.4.3-py2.py3-none-any.whl
Collecting pexpect<5,>=4.6.0 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/39/7b/88dbb785881c28a102619d46423cb853b46dbccc70d3ac362d99773a78ce/pexpect-4.8.0-py2.py3-none-any.whl
Collecting cookiecutter!=1.7.1,>=1.6.0 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/95/83/83ebf950ec99b02c61719ccb116462844ba2e873df7c4d40afc962494312/cookiecutter-1.7.2-py2.py3-none-any.whl
Collecting click-help-colors>=0.6 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/b1/57/10d5b653c2fb9a529459163126623b0d47c29653c95e4b8f0ee4bbc0cb5d/click_help_colors-0.8-py3-none-any.whl
Collecting sh<1.14,>=1.13.1 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/fa/9c/796934ee6d990d504c600056aa435e31bd49dbfba37e81d2045d37c8bdaf/sh-1.13.1-py2.py3-none-any.whl
Collecting yamllint<2,>=1.15.0 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/3d/cc/a68c1a8191a7d58188060bc0b1f8af38a5403772feb4ba8244059fc9eedb/yamllint-1.24.2-py2.py3-none-any.whl
Collecting paramiko<3,>=2.5.0 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/06/1e/1e08baaaf6c3d3df1459fd85f0e7d2d6aa916f33958f151ee1ecc9800971/paramiko-2.7.1-py2.py3-none-any.whl
Collecting python-gilt<2,>=1.2.1 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/ed/bc/5d8acdc51866880ee69dd908881758b3ccdbcf91a50bc1821a98a756fbf7/python_gilt-1.2.3-py2.py3-none-any.whl
Collecting cerberus>=1.3.1 (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/90/a7/71c6ed2d46a81065e68c007ac63378b96fa54c7bb614d653c68232f9c50c/Cerberus-1.3.2.tar.gz
Collecting docker>=2.0.0; extra == "docker" (from molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/3c/15/7a2f095a3b8b0fff9a0a5f56bd941e05fa958d4ca31105541001a5f7d3eb/docker-4.2.2-py2.py3-none-any.whl
Collecting pytest!=3.0.2 (from testinfra==5.2.2->-r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/9f/f3/0a83558da436a081344aa6c8b85ea5b5f05071214106036ce341b7769b0b/pytest-5.4.3-py3-none-any.whl
Collecting six>=1.4.1 (from cryptography->ansible==2.9.10->-r requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/ee/ff/48bde5c0f013094d729fe4b0316ba2a24774b3ff1c52d924a8a4cb04078a/six-1.15.0-py2.py3-none-any.whl
Collecting cffi!=1.11.3,>=1.8 (from cryptography->ansible==2.9.10->-r requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/f1/c7/72abda280893609e1ddfff90f8064568bd8bcb2c1770a9d5bb5edb2d1fea/cffi-1.14.0-cp36-cp36m-manylinux1_x86_64.whl
Collecting MarkupSafe>=0.23 (from jinja2->ansible==2.9.10->-r requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/b2/5f/23e0023be6bb885d00ffbefad2942bc51a620328ee910f64abe5a8d18dd1/MarkupSafe-1.1.1-cp36-cp36m-manylinux1_x86_64.whl
Collecting shellingham (from click-completion>=0.5.1->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/9f/6b/160e80c5386f7820f0a9919cc9a14e5aef2953dc477f0d5ddf3f4f2b62d0/shellingham-1.3.2-py2.py3-none-any.whl
Collecting importlib-metadata>=0.12; python_version < "3.8" (from pluggy<1.0,>=0.7.1->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/8e/58/cdea07eb51fc2b906db0968a94700866fc46249bdc75cac23f9d13168929/importlib_metadata-1.7.0-py2.py3-none-any.whl
Requirement already satisfied: setuptools>=39.0 in ./.venv/lib/python3.6/site-packages (from selinux; sys_platform == "linux"->molecule[docker]==3.0.5->-r requirements.txt (line 2))
Collecting distro>=1.3.0 (from selinux; sys_platform == "linux"->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/25/b7/b3c4270a11414cb22c6352ebc7a83aaa3712043be29daa05018fd5a5c956/distro-1.5.0-py2.py3-none-any.whl
Collecting ptyprocess>=0.5 (from pexpect<5,>=4.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/d1/29/605c2cc68a9992d18dada28206eeada56ea4bd07a239669da41674648b6f/ptyprocess-0.6.0-py2.py3-none-any.whl
Collecting jinja2-time>=0.2.0 (from cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/6a/a1/d44fa38306ffa34a7e1af09632b158e13ec89670ce491f8a15af3ebcb4e4/jinja2_time-0.2.0-py2.py3-none-any.whl
Collecting python-slugify>=4.0.0 (from cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/9f/42/e336f96a8b6007428df772d0d159b8eee9b2f1811593a4931150660402c0/python-slugify-4.0.1.tar.gz
Collecting requests>=2.23.0 (from cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/45/1e/0c169c6a5381e241ba7404532c16a21d86ab872c9bed8bdcd4c423954103/requests-2.24.0-py2.py3-none-any.whl
Collecting binaryornot>=0.4.4 (from cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/24/7e/f7b6f453e6481d1e233540262ccbfcf89adcd43606f44a028d7f5fae5eb2/binaryornot-0.4.4-py2.py3-none-any.whl
Collecting poyo>=0.5.0 (from cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/42/50/0b0820601bde2eda403f47b9a4a1f270098ed0dd4c00c443d883164bdccc/poyo-0.5.0-py2.py3-none-any.whl
Collecting pathspec>=0.5.3 (from yamllint<2,>=1.15.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/5d/d0/887c58853bd4b6ffc7aa9cdba4fc57d7b979b45888a6bd47e4568e1cf868/pathspec-0.8.0-py2.py3-none-any.whl
Collecting pynacl>=1.0.1 (from paramiko<3,>=2.5.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/9d/57/2f5e6226a674b2bcb6db531e8b383079b678df5b10cdaa610d6cf20d77ba/PyNaCl-1.4.0-cp35-abi3-manylinux1_x86_64.whl
Collecting bcrypt>=3.1.3 (from paramiko<3,>=2.5.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/8b/1d/82826443777dd4a624e38a08957b975e75df859b381ae302cfd7a30783ed/bcrypt-3.1.7-cp34-abi3-manylinux1_x86_64.whl
Collecting fasteners (from python-gilt<2,>=1.2.1->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/18/bd/55eb2d6397b9c0e263af9d091ebdb756b15756029b3cededf6461481bc63/fasteners-0.15-py2.py3-none-any.whl
Collecting websocket-client>=0.32.0 (from docker>=2.0.0; extra == "docker"->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/4c/5f/f61b420143ed1c8dc69f9eaec5ff1ac36109d52c80de49d66e0c36c3dfdf/websocket_client-0.57.0-py2.py3-none-any.whl
Collecting more-itertools>=4.0.0 (from pytest!=3.0.2->testinfra==5.2.2->-r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/ef/9b/6c35ec5483710492e21252465160ee508170159f7e0e2d6cd769022f52f6/more_itertools-8.4.0-py3-none-any.whl
Collecting wcwidth (from pytest!=3.0.2->testinfra==5.2.2->-r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/59/7c/e39aca596badaf1b78e8f547c807b04dae603a433d3e7a7e04d67f2ef3e5/wcwidth-0.2.5-py2.py3-none-any.whl
Collecting attrs>=17.4.0 (from pytest!=3.0.2->testinfra==5.2.2->-r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/a2/db/4313ab3be961f7a763066401fb77f7748373b6094076ae2bda2806988af6/attrs-19.3.0-py2.py3-none-any.whl
Collecting packaging (from pytest!=3.0.2->testinfra==5.2.2->-r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/46/19/c5ab91b1b05cfe63cccd5cfc971db9214c6dd6ced54e33c30d5af1d2bc43/packaging-20.4-py2.py3-none-any.whl
Collecting py>=1.5.0 (from pytest!=3.0.2->testinfra==5.2.2->-r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/68/0f/41a43535b52a81e4f29e420a151032d26f08b62206840c48d14b70e53376/py-1.9.0-py2.py3-none-any.whl
Collecting pycparser (from cffi!=1.11.3,>=1.8->cryptography->ansible==2.9.10->-r requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/ae/e7/d9c3a176ca4b02024debf82342dab36efadfc5776f9c8db077e8f6e71821/pycparser-2.20-py2.py3-none-any.whl
Collecting zipp>=0.5 (from importlib-metadata>=0.12; python_version < "3.8"->pluggy<1.0,>=0.7.1->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/b2/34/bfcb43cc0ba81f527bc4f40ef41ba2ff4080e047acb0586b56b3d017ace4/zipp-3.1.0-py3-none-any.whl
Collecting arrow (from jinja2-time>=0.2.0->cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/36/cf/9e503ab3007c531a7d773e65261ae2c732f7663185bf7e5091c5ea852846/arrow-0.15.7-py2.py3-none-any.whl
Collecting text-unidecode>=1.3 (from python-slugify>=4.0.0->cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/a6/a5/c0b6468d3824fe3fde30dbb5e1f687b291608f9473681bbf7dabbf5a87d7/text_unidecode-1.3-py2.py3-none-any.whl
Collecting idna<3,>=2.5 (from requests>=2.23.0->cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/a2/38/928ddce2273eaa564f6f50de919327bf3a00f091b5baba8dfa9460f3a8a8/idna-2.10-py2.py3-none-any.whl
Collecting urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1 (from requests>=2.23.0->cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/9f/f0/a391d1463ebb1b233795cabfc0ef38d3db4442339de68f847026199e69d7/urllib3-1.25.10-py2.py3-none-any.whl
Collecting certifi>=2017.4.17 (from requests>=2.23.0->cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/5e/c4/6c4fe722df5343c33226f0b4e0bb042e4dc13483228b4718baf286f86d87/certifi-2020.6.20-py2.py3-none-any.whl
Collecting chardet<4,>=3.0.2 (from requests>=2.23.0->cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/bc/a9/01ffebfb562e4274b6487b4bb1ddec7ca55ec7510b22e4c51f14098443b8/chardet-3.0.4-py2.py3-none-any.whl
Collecting monotonic>=0.1 (from fasteners->python-gilt<2,>=1.2.1->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/ac/aa/063eca6a416f397bd99552c534c6d11d57f58f2e94c14780f3bbf818c4cf/monotonic-1.5-py2.py3-none-any.whl
Collecting pyparsing>=2.0.2 (from packaging->pytest!=3.0.2->testinfra==5.2.2->-r requirements.txt (line 3))
  Using cached https://files.pythonhosted.org/packages/8a/bb/488841f56197b13700afd5658fc279a2025a39e22449b7cf29864669b15d/pyparsing-2.4.7-py2.py3-none-any.whl
Collecting python-dateutil (from arrow->jinja2-time>=0.2.0->cookiecutter!=1.7.1,>=1.6.0->molecule[docker]==3.0.5->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/d4/70/d60450c3dd48ef87586924207ae8907090de0b306af2bce5d134d78615cb/python_dateutil-2.8.1-py2.py3-none-any.whl
Building wheels for collected packages: ansible, click-completion, tree-format, cerberus, python-slugify
  Running setup.py bdist_wheel for ansible ... error
  Complete output from command /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/.venv/bin/python3 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-9z1vy66e/ansible/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" bdist_wheel -d /tmp/tmp7tt13dedpip-wheel- --python-tag cp36:
  usage: -c [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
     or: -c --help [cmd1 cmd2 ...]
     or: -c --help-commands
     or: -c cmd --help
  
  error: invalid command 'bdist_wheel'
  
  ----------------------------------------
  Failed building wheel for ansible
  Running setup.py clean for ansible
  Running setup.py bdist_wheel for click-completion ... error
  Complete output from command /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/.venv/bin/python3 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-9z1vy66e/click-completion/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" bdist_wheel -d /tmp/tmpo7kuz81mpip-wheel- --python-tag cp36:
  usage: -c [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
     or: -c --help [cmd1 cmd2 ...]
     or: -c --help-commands
     or: -c cmd --help
  
  error: invalid command 'bdist_wheel'
  
  ----------------------------------------
  Failed building wheel for click-completion
  Running setup.py clean for click-completion
  Running setup.py bdist_wheel for tree-format ... error
  Complete output from command /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/.venv/bin/python3 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-9z1vy66e/tree-format/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" bdist_wheel -d /tmp/tmppi1xbkk1pip-wheel- --python-tag cp36:
  usage: -c [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
     or: -c --help [cmd1 cmd2 ...]
     or: -c --help-commands
     or: -c cmd --help
  
  error: invalid command 'bdist_wheel'
  
  ----------------------------------------
  Failed building wheel for tree-format
  Running setup.py clean for tree-format
  Running setup.py bdist_wheel for cerberus ... error
  Complete output from command /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/.venv/bin/python3 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-9z1vy66e/cerberus/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" bdist_wheel -d /tmp/tmpsaky0w0_pip-wheel- --python-tag cp36:
  usage: -c [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
     or: -c --help [cmd1 cmd2 ...]
     or: -c --help-commands
     or: -c cmd --help
  
  error: invalid command 'bdist_wheel'
  
  ----------------------------------------
  Failed building wheel for cerberus
  Running setup.py clean for cerberus
  Running setup.py bdist_wheel for python-slugify ... error
  Complete output from command /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/.venv/bin/python3 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-9z1vy66e/python-slugify/setup.py';f=getattr(tokenize, 'open', open)(__file__);code=f.read().replace('\r\n', '\n');f.close();exec(compile(code, __file__, 'exec'))" bdist_wheel -d /tmp/tmpwa9o33k1pip-wheel- --python-tag cp36:
  usage: -c [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
     or: -c --help [cmd1 cmd2 ...]
     or: -c --help-commands
     or: -c cmd --help
  
  error: invalid command 'bdist_wheel'
  
  ----------------------------------------
  Failed building wheel for python-slugify
  Running setup.py clean for python-slugify
Failed to build ansible click-completion tree-format cerberus python-slugify
Installing collected packages: PyYAML, six, pycparser, cffi, cryptography, MarkupSafe, jinja2, ansible, click, shellingham, click-completion, zipp, importlib-metadata, pluggy, distro, selinux, tabulate, tree-format, colorama, ptyprocess, pexpect, python-dateutil, arrow, jinja2-time, text-unidecode, python-slugify, idna, urllib3, certifi, chardet, requests, binaryornot, poyo, cookiecutter, click-help-colors, sh, pathspec, yamllint, pynacl, bcrypt, paramiko, monotonic, fasteners, python-gilt, cerberus, websocket-client, docker, molecule, more-itertools, wcwidth, attrs, pyparsing, packaging, py, pytest, testinfra
  Running setup.py install for ansible ... done
  Running setup.py install for click-completion ... done
  Running setup.py install for tree-format ... done
  Running setup.py install for python-slugify ... done
  Running setup.py install for cerberus ... done
Successfully installed MarkupSafe-1.1.1 PyYAML-5.3.1 ansible-2.9.10 arrow-0.15.7 attrs-19.3.0 bcrypt-3.1.7 binaryornot-0.4.4 cerberus-1.3.2 certifi-2020.6.20 cffi-1.14.0 chardet-3.0.4 click-7.1.2 click-completion-0.5.2 click-help-colors-0.8 colorama-0.4.3 cookiecutter-1.7.2 cryptography-3.0 distro-1.5.0 docker-4.2.2 fasteners-0.15 idna-2.10 importlib-metadata-1.7.0 jinja2-2.11.2 jinja2-time-0.2.0 molecule-3.0.5 monotonic-1.5 more-itertools-8.4.0 packaging-20.4 paramiko-2.7.1 pathspec-0.8.0 pexpect-4.8.0 pluggy-0.13.1 poyo-0.5.0 ptyprocess-0.6.0 py-1.9.0 pycparser-2.20 pynacl-1.4.0 pyparsing-2.4.7 pytest-5.4.3 python-dateutil-2.8.1 python-gilt-1.2.3 python-slugify-4.0.1 requests-2.24.0 selinux-0.2.1 sh-1.13.1 shellingham-1.3.2 six-1.15.0 tabulate-0.8.7 testinfra-5.2.2 text-unidecode-1.3 tree-format-0.1.2 urllib3-1.25.10 wcwidth-0.2.5 websocket-client-0.57.0 yamllint-1.24.2 zipp-3.1.0
```
</p>
</details>

## How to test

Go to role directory and run molecule tests
```shell
cd roles/ansible-role-nginx
molecule test
```
<details><summary>output</summary>
<p>

```log
--> Test matrix
    
└── default
    ├── dependency
    ├── lint
    ├── cleanup
    ├── destroy
    ├── syntax
    ├── create
    ├── prepare
    ├── converge
    ├── idempotence
    ├── side_effect
    ├── verify
    ├── cleanup
    └── destroy
    
--> Scenario: 'default'
--> Action: 'dependency'
Skipping, missing the requirements file.
Skipping, missing the requirements file.
--> Scenario: 'default'
--> Action: 'lint'
--> Lint is disabled.
--> Scenario: 'default'
--> Action: 'cleanup'
Skipping, cleanup playbook not configured.
--> Scenario: 'default'
--> Action: 'destroy'
--> Sanity checks: 'docker'
    
    PLAY [Destroy] *****************************************************************
    
    TASK [Destroy molecule instance(s)] ********************************************
    changed: [localhost] => (item=centos-8)
    changed: [localhost] => (item=centos-7)
    
    TASK [Wait for instance(s) deletion to complete] *******************************
    FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '689118665223.23460', 'results_file': '/home/vscoder/.ansible_async/689118665223.23460', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '139240730848.23488', 'results_file': '/home/vscoder/.ansible_async/139240730848.23488', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    
    TASK [Delete docker network(s)] ************************************************
    
    PLAY RECAP *********************************************************************
    localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
    
--> Scenario: 'default'
--> Action: 'syntax'
    
    playbook: /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/ansible/ansible-role-nginx/molecule/default/converge.yml
--> Scenario: 'default'
--> Action: 'create'
    
    PLAY [Create] ******************************************************************
    
    TASK [Log into a Docker registry] **********************************************
    skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}) 
    skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}) 
    
    TASK [Check presence of custom Dockerfiles] ************************************
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    
    TASK [Create Dockerfiles from image names] *************************************
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    
    TASK [Discover local Docker images] ********************************************
    ok: [localhost] => (item={'diff': {'before': {'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8'}, 'after': {'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8'}}, 'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8', 'changed': False, 'uid': 1000, 'gid': 1000, 'owner': 'vscoder', 'group': 'vscoder', 'mode': '0664', 'state': 'file', 'size': 996, 'invocation': {'module_args': {'mode': None, 'follow': False, 'dest': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8', '_original_basename': 'Dockerfile.j2', 'recurse': False, 'state': 'file', 'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8', 'force': False, 'modification_time_format': '%Y%m%d%H%M.%S', 'access_time_format': '%Y%m%d%H%M.%S', '_diff_peek': None, 'src': None, 'modification_time': None, 'access_time': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None, 'content': None, 'backup': None, 'remote_src': None, 'regexp': None, 'delimiter': None, 'directory_mode': None, 'unsafe_writes': None}}, 'checksum': 'da2833c7bfbbf0c41991a97ecfbe2b5eac215b0d', 'dest': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8', 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
    ok: [localhost] => (item={'diff': {'before': {'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7'}, 'after': {'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7'}}, 'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7', 'changed': False, 'uid': 1000, 'gid': 1000, 'owner': 'vscoder', 'group': 'vscoder', 'mode': '0664', 'state': 'file', 'size': 996, 'invocation': {'module_args': {'mode': None, 'follow': False, 'dest': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7', '_original_basename': 'Dockerfile.j2', 'recurse': False, 'state': 'file', 'path': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7', 'force': False, 'modification_time_format': '%Y%m%d%H%M.%S', 'access_time_format': '%Y%m%d%H%M.%S', '_diff_peek': None, 'src': None, 'modification_time': None, 'access_time': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None, 'content': None, 'backup': None, 'remote_src': None, 'regexp': None, 'delimiter': None, 'directory_mode': None, 'unsafe_writes': None}}, 'checksum': '1b69eccc2a49ad979c357f356233d42a8cdcaada', 'dest': '/home/vscoder/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7', 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
    
    TASK [Build an Ansible compatible image (new)] *********************************
    ok: [localhost] => (item=molecule_local/centos:8)
    ok: [localhost] => (item=molecule_local/centos:7)
    
    TASK [Create docker network(s)] ************************************************
    
    TASK [Determine the CMD directives] ********************************************
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    
    TASK [Create molecule instance(s)] *********************************************
    changed: [localhost] => (item=centos-8)
    changed: [localhost] => (item=centos-7)
    
    TASK [Wait for instance(s) creation to complete] *******************************
    FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '336006832365.24288', 'results_file': '/home/vscoder/.ansible_async/336006832365.24288', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '787554771944.24315', 'results_file': '/home/vscoder/.ansible_async/787554771944.24315', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    
    PLAY RECAP *********************************************************************
    localhost                  : ok=7    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    
--> Scenario: 'default'
--> Action: 'prepare'
Skipping, prepare playbook not configured.
--> Scenario: 'default'
--> Action: 'converge'
    
    PLAY [Converge] ****************************************************************
    
    TASK [Gathering Facts] *********************************************************
    ok: [centos-8]
    ok: [centos-7]
    
    TASK [Include ansible-role-nginx] **********************************************
    
    TASK [ansible-role-nginx : include_vars] ***************************************
    ok: [centos-7]
    ok: [centos-8]
    
    TASK [ansible-role-nginx : include_tasks] **************************************
    included: /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/ansible/ansible-role-nginx/tasks/install_CentOS.yml for centos-7, centos-8
    
    TASK [ansible-role-nginx : Add repo] *******************************************
    changed: [centos-7]
    changed: [centos-8]
    
    TASK [ansible-role-nginx : Ensure openssl installed] ***************************
    changed: [centos-8]
    changed: [centos-7]
    
    TASK [ansible-role-nginx : Ensure nginx installed] *****************************
    changed: [centos-8]
    changed: [centos-7]
    
    TASK [ansible-role-nginx : include_tasks] **************************************
    included: /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/ansible/ansible-role-nginx/tasks/configure.yml for centos-7, centos-8
    
    TASK [ansible-role-nginx : Provide nginx site config] **************************
    changed: [centos-7]
    changed: [centos-8]
    
    TASK [ansible-role-nginx : include_tasks] **************************************
    included: /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/ansible/ansible-role-nginx/tasks/service.yml for centos-7, centos-8
    
    TASK [ansible-role-nginx : Enable and start service] ***************************
    changed: [centos-8]
    changed: [centos-7]
    
    RUNNING HANDLER [ansible-role-nginx : Reload nginx] ****************************
    included: /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/ansible/ansible-role-nginx/tasks/reload_nginx.yml for centos-7, centos-8
    
    RUNNING HANDLER [ansible-role-nginx : Check nginx config] **********************
    changed: [centos-8]
    changed: [centos-7]
    
    RUNNING HANDLER [ansible-role-nginx : Reload nginx] ****************************
    changed: [centos-8]
    changed: [centos-7]
    
    PLAY RECAP *********************************************************************
    centos-7                   : ok=13   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    centos-8                   : ok=13   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    
--> Scenario: 'default'
--> Action: 'idempotence'
Idempotence completed successfully.
--> Scenario: 'default'
--> Action: 'side_effect'
Skipping, side effect playbook not configured.
--> Scenario: 'default'
--> Action: 'verify'
--> Executing Testinfra tests found in /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/ansible/ansible-role-nginx/molecule/default/tests/...
    ============================= test session starts ==============================
    platform linux -- Python 3.6.9, pytest-5.4.3, py-1.9.0, pluggy-0.13.1
    rootdir: /home/vscoder/projects/otus/linux-2020-04/otus-linux/HW11-ansible/ansible/ansible-role-nginx/molecule/default
    plugins: testinfra-5.2.2
collected 12 items                                                             
    
    tests/test_default.py ............                                       [100%]
    
    ============================= 12 passed in 16.42s ==============================
Verifier completed successfully.
--> Scenario: 'default'
--> Action: 'cleanup'
Skipping, cleanup playbook not configured.
--> Scenario: 'default'
--> Action: 'destroy'
    
    PLAY [Destroy] *****************************************************************
    
    TASK [Destroy molecule instance(s)] ********************************************
    changed: [localhost] => (item=centos-8)
    changed: [localhost] => (item=centos-7)
    
    TASK [Wait for instance(s) deletion to complete] *******************************
    FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '904308980640.4916', 'results_file': '/home/vscoder/.ansible_async/904308980640.4916', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '767721546957.4943', 'results_file': '/home/vscoder/.ansible_async/767721546957.4943', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    
    TASK [Delete docker network(s)] ************************************************
    
    PLAY RECAP *********************************************************************
    localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
    
--> Pruning extra files from scenario ephemeral directory
```
</p>
</details>
