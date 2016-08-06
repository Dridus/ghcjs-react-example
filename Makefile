FRONTEND_STACK_PATH=$(shell cd frontend && stack path --dist-dir)/build/frontend-output/frontend-output.jsexe/

build: frontend backend

frontend:
	cd frontend && stack build
	ln -nfs $(PWD)/frontend/$(FRONTEND_STACK_PATH) backend/static/jsexe

frontend-watch:
	cd frontend && stack build --file-watch --fast

backend:
	cd backend && stack build

.PHONY: build frontend backend

