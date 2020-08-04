
# Create venv and install requirements
venv:
	test -d ./.venv || python3 -m venv ./.venv
	./.venv/bin/pip install -r requirements.txt
	@echo To activate venv, run:
	@echo source .venv/bin/activate

create:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule create

converge:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule converge

verify:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule verify

destroy:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule destroy


test:
	cd roles/ansible-role-nginx \
	&& ../../.venv/bin/molecule test


clean: destroy
