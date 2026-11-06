# Campus Notifier Team Notes

These notes contain team evidence for the twelve-drill submission. Replace
`[PENDING]` entries with the actual command output before submitting. Do not
record private keys, passwords, AWS credentials, registry tokens, or personal
host addresses unless the team explicitly decides that an address is safe to
publish.

## Team and repository

- Repository: `iclaudiaadeline/Ansible-Configuration-Management`
- Cloud/region: AWS / `eu-north-1`
- Team members: `[PENDING: names and GitHub handles]`
- Submission deadline: 6 November, 23:59 Kigali time

## Drill evidence

### Drill 1 — Terraform remote state

- Backend: encrypted S3 state with DynamoDB locking.
- Shared state key: `campus-notifier/terraform.tfstate`
- Bootstrap result: `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`
- Main Terraform backend initialization: completed.
- Account-local backend: used where the shared bucket was not accessible.

### Drills 2–3

- Result: `[PENDING: summarize the completed drill work and link reviewed PRs]`

### Drill 4 — Database box

- Terraform result: `3 added, 0 changed, 0 destroyed`.
- Database host output: `[PENDING: record the Terraform output name, not a secret]`
- SSH user: `ubuntu`
- Private key filename: `[PENDING: filename only; key remains outside Git]`
- SSH verification: `[PENDING: paste successful SSH result]`
- Database Ansible ping: `[PENDING: paste successful ping result]`
- SSH issue and fix: `[PENDING: describe the issue and resolution]`

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

- Results: `[PENDING: summarize each completed drill and add evidence links]`

## Pull requests and review

- Terraform pull request: `[PENDING: create or locate the reviewed PR]`
- Ansible pull request: `[PENDING: create or locate the reviewed PR]`
- Repository review check on 6 November 2026: no pull requests were found in
  the repository history available to this checkout or in the GitHub pull
  request listing.
- Both changes merged through reviewed pull requests: `[PENDING: confirm]`

## Security and repository hygiene

- No private keys, credentials, registry tokens, or account-local inventory are
  committed.
- `inventory.local.ini`, Terraform state, local backend overrides, and private
  key files are ignored.
- The NairobiPulse image reference must not contain embedded credentials.

## Teardown

- Current server status: `[PENDING: verify in AWS; local Terraform state could
  not be read because the AWS provider cache needs reinitialization]`
- Application host destroyed: `[PENDING: Terraform destroy result]`
- Database host destroyed: `[PENDING: Terraform destroy result]`
- Account-local state/bootstrap resources handled as required: `[PENDING]`
- AWS console or CLI verification that no assigned servers remain: `[PENDING]`
