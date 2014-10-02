REBAR = ./rebar
RECORDS_PATH = /home/sczaja/git/eshop/include

.PHONY: all compile test clean get-deps build-plt dialyze

all: compile

compile:
	@$(REBAR) compile

test: compile
	@$(REBAR) eunit skip_deps=true

clean:
	@$(REBAR) clean

get-deps:
	@$(REBAR) get-deps

build-plt:
	@$(REBAR) build-plt

dialyze: compile
	@$(REBAR) dialyze
