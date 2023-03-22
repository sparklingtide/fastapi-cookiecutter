test:
	sh ./tests/test_bare.sh

create_project:
	mkdir -p .cache && cd .cache/ && rm -rf * && cookiecutter ../
