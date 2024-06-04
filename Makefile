
# Base project path
BASE_PATH=.
# Path for Lambda layers folders
EXTERNAL_LIBS_FOLDER_PATH=$(BASE_PATH)/src/external_libs
# Path to the build folder 
BUILD_FOLDER=$(BASE_PATH)/build


# Development container name
DEV_CONTAINER_NAME=AWS_DATA_ENGINEERING_DEV_CONTAINER
# Development container image name with version
DEV_CONTAINER_IMAGE_NAME=AWS_DATA_ENGINEERING_DEV_CONTAINER:v1
# Value for the AWS_REGION environment variable to be used in the Dev Container
ENV_AWS_REGION=us-east-1
# Value for the AWS_ACCESS_KEY_ID environment variable to be used in the Dev Container
ENV_AWS_ACCESS_KEY_ID=
# Value for the AWS_SECRET_ACCESS_KEY environment variable to be used in the Dev Container
ENV_AWS_SECRET_ACCESS_KEY=
# Value for the AWS_SESSION_TOKEN environment variable to be used in the Dev Container
ENV_AWS_SESSION_TOKEN=

# ****************** Host only - Container Manipulation ******************

# Starts the development container. Use only if you can't use the VSCode "Dev Container" Extension
start-dev:
	@echo "Building dev container"
	@docker build -t $(DEV_CONTAINER_IMAGE_NAME) ./.devcontainer/
	@echo "Starting dev container"
	@docker run -t -d \
	-v ~/.aws:/home/glue_user/.aws \
	-v ./:/home/glue_user/workspace/ \
	-e AWS_PROFILE=$PROFILE_NAME \
	-e DISABLE_SSL=true \
	-e AWS_REGION=$(ENV_AWS_REGION) \
	-e AWS_ACCESS_KEY_ID=$(ENV_AWS_ACCESS_KEY_ID) \
	-e AWS_SECRET_ACCESS_KEY=$(ENV_AWS_SECRET_ACCESS_KEY) \
	-e AWS_SESSION_TOKEN=$(ENV_AWS_SESSION_TOKEN) \
	-e DATALAKE_FORMATS=hudi,delta,iceberg \
	--rm \
	-p 4040:4040 \
	-p 18080:18080 \
	--name $(DEV_CONTAINER_NAME) \
	$(DEV_CONTAINER_IMAGE_NAME)
	
	@echo "Setting up workspace permissions"
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /home/glue_user/workspace'
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /tmp/spark-events'

# Changes the owner of some folders to avoid permission issues
dev-permissions: 
	@echo "Setting up workspace permissions"
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /home/glue_user/workspace'
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /tmp/spark-events'
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /workspaces/'

# Stops the development container
stop-dev:
	@echo "Stopping dev container"
	@docker kill $(DEV_CONTAINER_NAME)

# ****************** Dev Container only - Environment Manipulation  ******************

# Creates environments for Lambda layers
create-external-libs-envs:
	@echo "Creating external libs environments"
	@for layer in $(shell ls $(EXTERNAL_LIBS_FOLDER_PATH)); do \
		if pyenv virtualenvs --bare --skip-aliases | grep -q "external_libs_env_$${layer}"; then \
			pyenv uninstall -f external_libs_env_$${layer}; \
		fi; \
		pyenv virtualenv 3.10 external_libs_env_$${layer}; \
	done

# Creates the Lambda environment
create-lambda-env:
	@echo "Creating lambda env environment"
	@if pyenv virtualenvs --bare --skip-aliases | grep -q "lambda_env"; then \
		pyenv uninstall -f lambda_env; \
	fi

	@pyenv virtualenv 3.10 lambda_env


# Creates the Python Shell environment
create-python-shell-env:
	@echo "Creating python shell environment"
	@if pyenv virtualenvs --bare --skip-aliases | grep -q "python_shell_env"; then \
		pyenv uninstall -f python_shell_env; \
	fi

	@pyenv virtualenv 3.9 python_shell_env

# Creates the Spark environment
create-spark-env:
	@echo "Creating spark environment"
	@if pyenv virtualenvs --bare --skip-aliases | grep -q "spark_env"; then \
		pyenv uninstall -f spark_env; \
	fi

	@pyenv virtualenv 3.10 spark_env

# Creates all environments
create-envs: create-lambda-env create-python-shell-env create-spark-env create-external-libs-envs

# Clears all environments
clear-envs:
	@echo "Clearing environments"
	@for env in $$(pyenv virtualenvs --bare --skip-aliases); do \
		echo "Uninstalling $${env}"; \
		pyenv uninstall -f $${env}; \
	done

# ****************** Dev Container only - Dependencies and External Libs build  ******************

# Installs external libs in current environment
install-external-libs:
	@echo "Installing lambda layers"
	@for layer in $(shell ls $(EXTERNAL_LIBS_FOLDER_PATH)); do \
		echo "Installing layer $${layer}"; \
		pip install --use-pep517 $(EXTERNAL_LIBS_FOLDER_PATH)/$${layer} ; \
		rm -rf $(EXTERNAL_LIBS_FOLDER_PATH)/$${layer}/build ; \
		rm -rf $(EXTERNAL_LIBS_FOLDER_PATH)/$${layer}/*.egg-info ; \
	done

# Zips the external libs into a zip file for lambda layers use and wheel for Glue jobs
# Arguments:
# 1 - External lib folder path

.PHONY: build

INPUT_EXTERNAL_LIB_NAME=$(word 2, $(MAKECMDGOALS))

VAR_EXTERNAL_LIB_FOLDER_PATH=$(EXTERNAL_LIBS_FOLDER_PATH)/$(INPUT_EXTERNAL_LIB_NAME)
VAR_STG_FOLDER=$(BUILD_FOLDER)/$(INPUT_EXTERNAL_LIB_NAME)
VAR_SITE_PACKAGES_PATH=$(VAR_STG_FOLDER)/python/lib/python3.10/site-packages
VAR_ZIP_FILE=$(BUILD_FOLDER)/external_lib_$(INPUT_EXTERNAL_LIB_NAME).zip
build:

	@if [ -z $(INPUT_EXTERNAL_LIB_NAME) ]; then \
		echo "Please provide the external lib folder path"; \
		exit 1; \
	fi ;

	@if [ ! -d $(VAR_EXTERNAL_LIB_FOLDER_PATH) ]; then \
		echo "External lib folder $(VAR_EXTERNAL_LIB_FOLDER_PATH) not found"; \
		exit 1; \
	fi ;

	@echo "Building external lib ${INPUT_EXTERNAL_LIB_NAME} to zip"
	@rm -rf $(VAR_STG_FOLDER)
	@mkdir -p $(VAR_SITE_PACKAGES_PATH)
	@pip3 install --use-pep517 --no-cache-dir $(VAR_EXTERNAL_LIB_FOLDER_PATH) -t $(VAR_SITE_PACKAGES_PATH)
	@rm -rf $(VAR_EXTERNAL_LIB_FOLDER_PATH)/build
	@rm -rf $(VAR_EXTERNAL_LIB_FOLDER_PATH)/*.egg-info 
	@cd $(VAR_STG_FOLDER) && zip -r ../$(INPUT_EXTERNAL_LIB_NAME).zip .
	@rm -rf $(VAR_STG_FOLDER)

	@echo "External lib ${INPUT_EXTERNAL_LIB_NAME} built to zip"

	@echo "Building external lib ${INPUT_EXTERNAL_LIB_NAME} to wheel"
	@rm -rf $(VAR_STG_FOLDER)
	@mkdir -p $(VAR_SITE_PACKAGES_PATH)
	@pip3 install wheel 
	@python3 $(VAR_EXTERNAL_LIB_FOLDER_PATH)/setup.py bdist_wheel --dist-dir=$(BUILD_FOLDER)
	@rm -rf $(VAR_STG_FOLDER)
	@rm -rf $(BUILD_FOLDER)/bdist.*
	@rm -rf *.egg-info

	@echo "External lib ${INPUT_EXTERNAL_LIB_NAME} built to wheel"

# ****************** Dev Container only - Deploy  ******************

# Calculates the infrastructure deployment plan
deploy-plan:
	@cd ./infra && terraform init && terraform plan

# Deploys the infrastructure
deploy:
	@cd ./infra && terraform init && terraform apply -auto-approve

%:
	@: