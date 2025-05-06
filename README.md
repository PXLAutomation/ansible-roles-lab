# Ansible Roles Lab

This project demonstrates a structured Ansible deployment using roles, inventories, and playbook organization techniques. The example is not complex on purpose and manages web and database servers.

## Directory Structure

```
ansible-roles-lab/
├── ansible.cfg                # Main Ansible configuration
├── site.yml                   # Main playbook entry point
├── webservers.yml             # Web server playbook
├── dbservers.yml              # Database server playbook
├── inventory/                 # Inventory directory
│   ├── production/            # Production environment
│   │   ├── hosts              # Production inventory hosts file
│   │   └── group_vars/        # Production variables
│   │       ├── all.yml        # Variables for all hosts
│   │       ├── webservers.yml # Variables for web servers
│   │       └── dbservers.yml  # Variables for database servers
│   └── staging/               # Staging environment
│       ├── hosts              # Staging inventory hosts file
│       └── group_vars/        # Staging variables
│           └── all.yml        # Variables for all hosts
├── roles/                     # Roles directory
│   ├── myinfra/               # Infrastructure role (created with ansible-galaxy init --offline)
│   │   ├── defaults/          # Default variables
│   │   ├── files/             # Static files
│   │   ├── handlers/          # Handlers
│   │   ├── meta/              # Role metadata
│   │   ├── tasks/             # Task definitions
│   │   │   ├── main.yml       # Main tasks entry point
│   │   │   ├── common.yml     # Common tasks
│   │   │   ├── webserver.yml  # Web server tasks
│   │   │   ├── database.yml   # Database tasks
│   │   │   └── firewall.yml   # Firewall tasks
│   │   └── templates/         # Jinja2 templates
│   └── requirements.yml       # External role dependencies
└── Vagrantfile                # Vagrant configuration for test environment
```

## Inventory Structure

The inventory directory contains environment-specific configurations:

- **hosts file**: Defines servers and groups
- **group_vars directory**: Contains variables organized by server groups defined in the inventory file(s)
  - Located within each environment directory (e.g., `inventory/production/group_vars/`)
  - Variables cascade from general (`all.yml`) to specific (`webservers.yml`, `dbservers.yml`)

## Role Structure

The `roles/myinfra` directory was created using `ansible-galaxy init --offline myinfra` command, which scaffolds a complete role structure:

- **defaults/main.yml**: Default variables that can be overridden
- **files/**: Static files to be copied to remote hosts
- **handlers/main.yml**: Handlers that can be notified by tasks
- **meta/main.yml**: Role metadata including dependencies
- **tasks/**: Organized task files
  - **main.yml**: Entry point that includes other task files
  - **common.yml**, **webserver.yml**, etc.: Specialized task files
- **templates/**: Jinja2 templates that are rendered before deployment

## Playbook Organization

The project uses a hierarchical playbook structure:

- **site.yml**: Main entry point that imports other playbooks
- **webservers.yml**: Configures web servers using the myinfra role
- **dbservers.yml**: Configures database servers using the myinfra role with custom variables

### Import vs Include

The project demonstrates two different methods for using playbooks and tasks:

- **Import (`import_playbook`, `import_tasks`)**: 
  - Used in `site.yml` with `import_playbook: webservers.yml`
  - Processed at playbook parsing time (static)
  - Variables are evaluated at parse time
  - Better performance for large playbooks
  - All imported tasks appear in play outputs

- **Include (`include_tasks`)**: 
  - Used in `roles/myinfra/tasks/main.yml` with `include_tasks: webserver.yml`
  - Processed at runtime when the task is encountered (dynamic)
  - Variables are evaluated at execution time
  - Allows for conditional inclusion using variables determined at runtime
  - Only the include task appears in outputs, not the individual included tasks

## Task Organization

The main task file (`roles/myinfra/tasks/main.yml`) serves as a controller that:

1. Includes specialized task files based on server group membership:
   ```yaml
   - name: Include web server tasks
     include_tasks: webserver.yml
     when: "'webservers' in group_names"
   ```

2. Uses conditionals to determine which tasks to run
3. Provides a central entry point for all role tasks
4. Maintains organization by separating concerns into different files

This modular approach improves maintainability by:
- Keeping related tasks grouped together
- Making it easier to find and update specific functionality
- Allowing selective inclusion of tasks based on server roles