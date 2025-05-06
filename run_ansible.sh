#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initial run of playbook
echo -e "\n${YELLOW}Running site.yml playbook...${NC}"
ansible-playbook -i ./inventory/production/hosts site.yml
PLAYBOOK_EXIT=$?

if [ $PLAYBOOK_EXIT -ne 0 ]; then
    echo -e "${RED}Playbook execution failed with exit code $PLAYBOOK_EXIT.${NC}"
    exit 1
else
    echo -e "${GREEN}Playbook executed successfully.${NC}"
fi