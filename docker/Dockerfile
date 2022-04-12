FROM python:3.10 as venv_builder
WORKDIR /opt/automation
RUN python -m venv venv
RUN venv/bin/pip install awscli --no-cache-dir
RUN venv/bin/pip install ansible --no-cache-dir
RUN venv/bin/pip install pywinrm --no-cache-dir

FROM python:3.10 as addon_builder
WORKDIR /opt/automation
COPY . .

FROM python:3.10 as terraform_builder
WORKDIR /opt/automation
ARG TF_VERSION=1.0.7
RUN wget "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" -q
RUN unzip terraform_${TF_VERSION}_linux_amd64.zip

FROM python:3.10 as jq_builder
WORKDIR /opt/automation
ARG JQ_VERSION=1.6
RUN wget "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" -O jq -q
RUN chmod +x jq

FROM python:3.10
COPY --from=jq_builder /opt/automation/jq /usr/local/bin/
COPY --from=terraform_builder /opt/automation/terraform /usr/local/bin/
COPY --from=venv_builder /opt/automation/venv /opt/automation/venv
COPY --from=addon_builder /opt/automation /opt/automation/tools
ENV VIRTUAL_ENV /opt/automation/venv
ENV PATH /opt/automation/venv/bin:$PATH
ENV ANSIBLE_CONFIG /opt/automation/tools/ansible/ansible.cfg
ENV ANSIBLE_HOST_KEY_CHECKING False
WORKDIR /opt/automation/tools/