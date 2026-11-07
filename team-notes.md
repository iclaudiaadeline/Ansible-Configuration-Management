# Campus Notifier Team Notes

These notes contain team evidence for the twelve-drill submission. Do not
record private keys, passwords, AWS credentials, registry tokens, or personal
host addresses unless the team explicitly decides that an address is safe to
publish.

## Team and repository

- Repository: `iclaudiaadeline/Ansible-Configuration-Management`
- Cloud/region: AWS / `eu-north-1`
- Team members: Bienvenu, Victor, Adeline, Olive
- Submission deadline: 6 November, 23:59 Kigali time

## Drill evidence

### Drill 1 — Terraform remote state

- Backend: encrypted S3 state with DynamoDB locking.
- Shared state key: `campus-notifier/terraform.tfstate`
- Bootstrap result: `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`
- Main Terraform backend initialization: completed.
- Account-local backend: used where the shared bucket was not accessible.

### Drills 2–3

- Result: no evidence was recorded for these drills.

### Drill 4 — Database box

- Terraform result: `3 added, 0 changed, 0 destroyed`.
- Database host output: `database_public_ip`
- SSH user: `ubuntu`
- Private key filename: not recorded. The key stayed outside Git; its AWS key
  pair name was `campus-notifier-db-admin`.
- SSH verification: SSH to the database host as `ubuntu` returned `SSH_OK`.
- Database Ansible ping: `ansible -i inventory.local.ini database -m ping`
  returned `database_box | SUCCESS`, `changed: false`, `ping: pong`.
- SSH issue and fix: registered the public key in EC2, loaded the private key
  locally, limited inbound SSH to the current client `/32`, and enabled
  `accept-new` host-key handling in Ansible.

### Drill 5 — Application host and Ansible

#### Inventory and connectivity

- Inventory host: `nairobi_pulse`
- Terraform output used: `application_public_ip`
- Ansible command:

  ```text
  ansible -i inventory.local.ini campus_notifier -m ping
  ```

- Result:

  ```text
  nairobi_pulse | SUCCESS => {
      "changed": false,
      "ping": "pong"
  }
  ```

- Facts gathered: `ansible_facts['os_family'] == 'Debian'` confirmed by the
  pre-task assert before any changes were made.

#### Docker installation

- Playbook: `playbook.yml`
- Installation module: `ansible.builtin.apt`
- Service module: `ansible.builtin.service`
- Verification result:

  ```text
  TASK [Install Docker] ............. changed: [nairobi_pulse]
  TASK [Enable and start Docker] .... ok: [nairobi_pulse]
  ```

#### NairobiPulse deployment and health

- Image: `traefik/whoami:latest` (stand-in; facilitator-supplied NairobiPulse
  image was not published before the deadline)
- Deployment module: `community.docker.docker_container`
- First run result:

  ```text
  TASK [Run NairobiPulse] ........... changed: [nairobi_pulse]
  TASK [Wait for NairobiPulse health endpoint] ... ok: [nairobi_pulse -> localhost]
  ```

- Health command/result:

  ```text
  curl -s -o /dev/null -w "%{http_code}" http://13.61.142.64:3000/health
  200
  ```

#### Idempotence

- First command:

  ```text
  ansible-playbook -i inventory.local.ini playbook.yml
  ```

- First run recap:

  ```text
  nairobi_pulse : ok=7  changed=2  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
  ```

- Second command:

  ```text
  ansible-playbook -i inventory.local.ini playbook.yml
  ```

- Second run recap:

  ```text
  nairobi_pulse : ok=7  changed=0  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
  ```

- Health after second run: `curl http://13.61.142.64:3000/health` returned `200`.
- Explanation: The container is managed declaratively with
  `community.docker.docker_container`, so the second run does not recreate it
  when its configuration already matches the declared state.

### Drills 6–12

- Results: no evidence was recorded for these drills.

## Security and repository hygiene

- No private keys, credentials, registry tokens, or account-local inventory are
  committed.
- `inventory.local.ini`, Terraform state, local backend overrides, and private
  key files are ignored.
- The NairobiPulse image reference must not contain embedded credentials.

## Teardown

- Current server status: destroyed.
- Application and database hosts destroyed:

  ```text
  Destroy complete! Resources: 5 destroyed.
  ```

- Account-local state and bootstrap resources handled.
- No assigned servers remain in the account.
