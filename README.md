- Create virtual machine(Ubuntu/2GM Memory) and DNS records

    Run following Cmds on vitual machine to get latest patches:
    ```
    sudo apt update && sudo apt -y upgrade
    ```

    DNS records examples for the controller and odoo builds live endpoint:

    - Controller(A record): `runboat-controller-tmp.{base-domain} instance-IP`
    - Builds(A record): `*.runboat-builds-tmp.{base-domain} instance-IP`

- Create postgres database instance and collect credentials
    Example root username and password

    DB root user: root
    DB root pass: runboat_runboat
    DB hostname:  runboat.csej1ip8qm8x.us-east-1.rds.amazonaws.com

- Open Database instance `5432` port and disable external fire wall(if any) to the virtual machine for ease of installation. We should turn this back on after setup is complete

- Update/check firewalls so that the virtual machine can connect to database

- Login into virtual machine and check if the virtual machine can connect to the database
    Install psql client:
    ```
    sudo apt install postgresql-client-common
    sudo apt install postgresql-client-14
    ```
    Check database connection:
    ```
    PGPASSWORD='runboat_runboat' psql -h runboat.csej1ip8qm8x.us-east-1.rds.amazonaws.com -d postgres -U root
    ```
- `ssh` into the instance and clone project repo
  - `git clone --recursive https://github.com/strativ-dev/runboat-deployment.git`

- Configure Kubernetes using microk8s
  - Run `runboat-deployment/resources/microk8s-setup.sh` script and exit the ssh session
  - Login back and run `runboat-deployment/resources/haproxy-install.sh`

- Configure oca runboat repo and make adjustments
  - Change directory into runboat repo: `cd runboat-deployment/runboat/`
  - Create kubeconfig: `microk8s config > kubeconfig`
  - Copy docker-compose.yml: `cp ../resources/docker-compose.yml .`
  - Update docker-compose.yml:
    - put DB connection details at `RUNBOAT_BUILD_ENV`. Example: `runboat-controller-tmp.erp360.strativ.se`
    - put DB password at `RUNBOAT_BUILD_SECRET_ENV`
    - put Controller url at `RUNBOAT_BASE_URL`. Example: `http://runboat.erp360.strativ.se:8000`
    - put Builds domain at `RUNBOAT_BUILD_DOMAIN`. Example: `runboat-builds-tmp.erp360.strativ.se`
    - create personal github token from `https://github.com/settings/tokens/new` with permissions and put at `RUNBOAT_GITHUB_TOKEN`
    - Configure webhook url
      - Put `{base-url}:8000/webhooks/github` at `Payload URL` section
      - Set `Content type` to `application/json`
      - Put a secret value at *Secret* section and update `RUNBOAT_GITHUB_WEBHOOK_SECRET` at `docker-compose.yml`