FRONTEND_STACK_PATH=$(shell cd frontend && stack path --dist-dir)/build/frontend-output/frontend-output.jsexe/
MY_NODE_PATH=/usr/local/lib/node_modules

build: frontend backend

frontend:
	cd frontend && stack build
	ln -nfs $(PWD)/frontend/$(FRONTEND_STACK_PATH) backend/static/jsexe

frontend-watch:
	cd frontend && stack build --file-watch --fast

ghcjsi:
	export NODE_PATH=$(MY_NODE_PATH)
	cd frontend && stack exec -- ghcjs --interactive

backend:
	cd backend && stack build

.PHONY: build frontend backend
