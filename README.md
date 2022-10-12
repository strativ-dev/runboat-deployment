- Create virtual machine(Ubuntu/2GM Memory) and DNS records

    Run following Cmds on vitual machine to get latest patches:
    ```
    sudo apt update && sudo apt -y upgrade
    ```

    DNS records examples for the controller and odoo builds live endpoint:

    Controller(A record): runboat-controller-tmp.base-domain IP
    Builds(A record): *.runboat-builds-tmp.base-domain IP

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
- Configure Kubernetes using microk8s
  - Run `microk8s-setup.sh` script and exit the ssh session
  - Login back and run `haproxy-install.sh`