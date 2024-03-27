PLATFORM = $(shell uname)

PROJECT_NAME=lexical
PROJECT_TAG?=lexical
PUBLIC_PROJECT=true
GITHUB_DOMAIN=github.com
GITHUB_TOKEN?=must be present on your env.mk, create in github at setting/user developer/external token with repo scope
GITHUB_PROJECT=gutomaia/lexical
MAKEFILE_SCRIPT_PATH=extras/makefiles
MAKERY_REPOSITORY=gutomaia/makery
MAKERY_SCRIPT=gutonet.mk
MAKERY_DEFAULT_TASK=default_makery
MAKERY_BASE_URL=https://raw.githubusercontent.com/${MAKERY_REPOSITORY}/master

PYTHON_VERSION?=3.11
PYTHON_MODULES=lexical

WGET=wget -q
ifeq "true" "${PUBLIC_PROJECT}"
GH_WGET=${WGET}
else
GH_WGET=${WGET} --header "Authorization: token ${GITHUB_TOKEN}"
endif

ifeq "" "$(shell which wget)"
WGET=curl -O -s -L -s
ifeq "true" "${PUBLIC_PROJECT}"
GH_WGET=${WGET}
else
GH_WGET=${WGET} -H "Authorization: token ${GITHUB_TOKEN}"
endif
endif

OK=\033[32m[OK]\033[39m
FAIL=\033[31m[FAIL]\033[39m
CHECK=@if [ $$? -eq 0 ]; then echo "${OK}"; else echo "${FAIL}" ; fi


ifeq "true" "${shell test -f ~/env.mk && echo true}"
include ~/env.mk
HASENV=true
endif


ifeq "true" "${shell test -f env.mk && echo true}"
include env.mk
HASENV=true
endif

ifneq "true" "${HASENV}"
$(shell echo "# Generated file env.mk" > env.mk)
$(shell echo "GITHUB_TOKEN=" > env.mk)
endif

ifeq "" "${GITHUB_TOKEN}"
default:
	echo ${GITHUB_TOKEN} ${shell test -f ~/env.mk && echo true}
	@echo "You must create a GITHUB_TOKEN var in your env.mk file"
	@echo "Create a token with REPO permissions and set as GITHUB_TOKEN in your env.mk"
	@echo "Go to https://github.com/settings/tokens (y/N)?" && read ans && [ $${ans:-N} = y ]
	@open https://github.com/settings/tokens
	@exit 1
else
default: ${MAKEFILE_SCRIPT_PATH}/${MAKERY_SCRIPT}
	@$(MAKE) -C . ${MAKERY_DEFAULT_TASK}
endif

ifeq "true" "${shell test -f ${MAKEFILE_SCRIPT_PATH}/${MAKERY_SCRIPT} && echo true}"
include ${MAKEFILE_SCRIPT_PATH}/${MAKERY_SCRIPT}
endif

${MAKEFILE_SCRIPT_PATH}/${MAKERY_SCRIPT}:
	@echo "Download ${MAKERY_SCRIPT} at extras/makefiles: \c"
	@mkdir -p ${MAKEFILE_SCRIPT_PATH} && \
		cd ${MAKEFILE_SCRIPT_PATH} && \
		${GH_WGET} ${MAKERY_BASE_URL}/${MAKERY_SCRIPT} && \
		touch ${MAKERY_SCRIPT}
	${CHECK}


run:
	${VIRTUALENV} python ${PYTHON_MODULES}