
DEV_CONTAINER_NAME=AWS_DATA_ENGINEERING_DEV_CONTAINER 					# Nome do container de desenvolvimento
DEV_CONTAINER_IMAGE_NAME=AWS_DATA_ENGINEERING_DEV_CONTAINER:v1 			# Nome da imagem do container de desenvolvimento com a versão
BASE_PATH=. 														# Caminho base do projeto
VENV_FOLDER=$(BASE_PATH)/.venv 										# Pasta do ambiente virtual
EXTERNAL_LIBS_FOLDER_PATH=$(BASE_PATH)/src/external_libs 			# Caminho para as pastas das camadas Lambda
ENV_AWS_REGION=us-east-1 											# Valor para a variável de ambiente AWS_REGION que será usada no Dev Container 
ENV_AWS_ACCESS_KEY_ID= 												# Valor para a variável de ambiente AWS_ACCESS_KEY_ID que será usada no Dev Container
ENV_AWS_SECRET_ACCESS_KEY= 											# Valor para a variável de ambiente AWS_SECRET_ACCESS_KEY que será usada no Dev Container
ENV_AWS_SESSION_TOKEN= 												# Valor para a variável de ambiente AWS_SESSION_TOKEN que será usada no Dev Container

# ****************** Apenas para o host ******************

# Inicia o container de desenvolvimento. Usar apenas se não for possível utilizar a Extensão do VSCode "Dev Container"
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

# Muda o dono de algumas pastas com a finalidade de evitar problemas de permissão
dev-permissions: 
	@echo "Setting up workspace permissions"
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /home/glue_user/workspace'
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /tmp/spark-events'
	@docker exec -u 0 $(DEV_CONTAINER_NAME) bash -c 'chown -R glue_user /workspaces/'

# Para o container de desenvolvimento
stop-dev:
	@echo "Stopping dev container"
	@docker kill $(DEV_CONTAINER_NAME)

# ****************** Apenas para o container de desenvolvimento ******************

# Cria ambientes para as camadas Lambda
create-external-libs-envs:
	@echo "Creating lambda layers environments"
	@pyenv versions --bare | grep -q "^lambda_layers_env$$" || pyenv virtualenv 3.10 lambda_layers_env
	@pyenv local lambda_layers_env
	@for layer in $(shell ls $(EXTERNAL_LIBS_FOLDER_PATH)); do \
		rm -rf $(VENV_FOLDER)/local_lambda_layers_env_$${layer}; \
		python -m venv $(VENV_FOLDER)/local_lambda_layers_env_$${layer}; \
	done

# Cria o ambiente Lambda
create-lambda-env:
	@echo "Creating lambda environment"
	@pyenv versions --bare | grep -q "^lambda_env$$" || pyenv virtualenv 3.10 lambda_env
	@pyenv local lambda_env 
	@rm -rf $(VENV_FOLDER)/local_lambda_env
	@python -m venv $(VENV_FOLDER)/local_lambda_env

# Cria o ambiente Python Shell
create-python-shell-env:
	@echo "Creating python shell environment"
	@pyenv versions --bare | grep -q "^python_shell_env$$" || pyenv virtualenv 3.9 python_shell_env
	@pyenv local python_shell_env
	@rm -rf $(VENV_FOLDER)/local_python_shell_env
	@python -m venv $(VENV_FOLDER)/local_python_shell_env

# Cria o ambiente Spark
create-spark-env:
	@echo "Creating spark environment"
	@pyenv versions --bare | grep -q "^spark_env$$" || pyenv virtualenv 3.10 spark_env
	@pyenv local spark_env
	@rm -rf $(VENV_FOLDER)/local_spark_env
	@python -m venv $(VENV_FOLDER)/local_spark_env

# Cria todos os ambientes
create-envs: create-lambda-env create-python-shell-env create-spark-env create-external-libs-envs

# Limpa todos os ambientes
clear-envs:
	@echo "Clearing environments"
	@rm -rf $(VENV_FOLDER)

# Instala as camadas Lambda
install-external-libs:
	@echo "Installing lambda layers"
	@for layer in $(shell ls $(EXTERNAL_LIBS_FOLDER_PATH)); do \
		source $(VENV_FOLDER)/local_lambda_env/bin/activate ; \
		echo "Installing layer $${layer}"; \
		pip install --use-pep517 $(EXTERNAL_LIBS_FOLDER_PATH)/$${layer} ; \
		rm -rf $(EXTERNAL_LIBS_FOLDER_PATH)/$${layer}/build ; \
		rm -rf $(EXTERNAL_LIBS_FOLDER_PATH)/$${layer}/*.egg-info ; \
	done

# Reseta o ambiente Lambda, recriando-o e instalando as camadas
reset-lambda-env: create-lambda-env install-layers

# Atualiza os requisitos dos ambientes
update-requirements:
	@echo "Updating requirements of Lambda Env"
	@pyenv local lambda_env 
	@pyenv exec pip freeze > ./datalake/lambda/requirements.txt
	@echo "Updating requirements of Python Shell Env"
	@pyenv local python_shell_env
	@pyenv exec pip freeze > ./datalake/python_shell/requirements.txt
	@echo "Updating requirements of Spark Env"
	@pyenv local spark_env
	@pyenv exec pip freeze > ./datalake/spark/requirements.txt

# Calcula o plano de deploy da infraestrutura 
deploy-plan:
	@cd ./infra && terraform init && terraform plan

# Realiza o deploy da infraestrutura
deploy:
	@cd ./infra && terraform init && terraform apply -auto-approve