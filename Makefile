.PHONY : all clean build upload

all: install clean

clean:
	@rm -rf `find ./ -type d -name "*__pycache__"`
	@rm -rf ./build/ ./dist/ ./sharehound.egg-info/

docs:
	@python3 -m pip install pdoc --break-system-packages
	@echo "[$(shell date)] Generating docs ..."
	@PDOC_ALLOW_EXEC=1 python3 -m pdoc -d markdown -o ./documentation/ ./sharehound/
	@echo "[$(shell date)] Done!"

uninstall:
	python3 -m pip uninstall sharehound --yes --break-system-packages

install: build
	pip install . --break-system-packages

build:
	python3 -m pip uninstall sharehound --yes --break-system-packages
	python3 -m pip install .[build] --break-system-packages
	python3 -m build --wheel

upload: build
	python3 -m pip install .[twine] --break-system-packages
	python3 -m twine upload dist/*

test:
	@echo "[$(shell date)] Running tests ..."
	@cd sharehound/tests && python3 run_tests.py
	@echo "[$(shell date)] Tests completed!"

test-verbose:
	@echo "[$(shell date)] Running tests with verbose output ..."
	@cd sharehound/tests && python3 -m unittest discover -v
	@echo "[$(shell date)] Tests completed!"

test-coverage:
	@echo "[$(shell date)] Installing coverage and running tests with coverage ..."
	@python3 -m pip install coverage --break-system-packages
	@coverage run --source=sharehound sharehound/tests/run_tests.py
	@coverage report
	@coverage html
	@echo "[$(shell date)] Coverage report generated in htmlcov/"


lint:
	@echo "[$(shell date)] Installing linting tools ..."
	@python3 -m pip install flake8 black isort --break-system-packages
	@echo "[$(shell date)] Running flake8 linting ..."
	@python3 -m flake8 sharehound/ --max-line-length=88 --extend-ignore=E501,E203
	@echo "[$(shell date)] Running black code formatting check ..."
	@python3 -m black --check --diff sharehound/
	@echo "[$(shell date)] Running isort import sorting check ..."
	@python3 -m isort --check-only --diff sharehound/
	@echo "[$(shell date)] Linting completed!"

lint-fix:
	@echo "[$(shell date)] Installing linting tools ..."
	@python3 -m pip install flake8 black isort --break-system-packages
	@echo "[$(shell date)] Running black to fix formatting issues ..."
	@python3 -m black sharehound/
	@echo "[$(shell date)] Running isort to fix import sorting ..."
	@python3 -m isort sharehound/
	@echo "[$(shell date)] Running flake8 to check remaining issues ..."
	@python3 -m flake8 sharehound/ --max-line-length=88 --extend-ignore=E501,E203
	@echo "[$(shell date)] Code formatting fixes completed!"