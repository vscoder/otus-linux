MOLECULE_DRIVER?=vagrant
MOLECULE_VERIFIER?=testinfra
ANSIBLE_ROLE_NAME?=common
ANSIBLE?=./.venv/bin/ansible

# Create venv and install requirements
venv:
	test -d ./.venv || python3 -m venv ./.venv
	./.venv/bin/pip install -r requirements.txt
	@echo To activate venv, run:
	@echo source .venv/bin/activate

# Init new role with molecule
molecule_init_role:
	cd roles \
	&& ../.venv/bin/molecule init role \
		--driver-name $(MOLECULE_DRIVER) \
		--verifier-name $(MOLECULE_VERIFIER) \
		ansible-role-$(ANSIBLE_ROLE_NAME)
	@echo "Don't forget to update ./roles/ansible-role-$(ANSIBLE_ROLE_NAME)/meta/main.yml"

ansible_requirements:
	${ANSIBLE}-galaxy install -r ./requirements.yml --force
