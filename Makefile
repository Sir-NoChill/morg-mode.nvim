.PHONY: test lint format check api-documentation llscheck coverage-html check-mdformat download-dependencies

CONFIGURATION = .luarc.json

# Download LSP type annotation dependencies
download-dependencies:
	git clone git@github.com:Bilal2453/luvit-meta.git .dependencies/luvit-meta 2>/dev/null || true
	git clone git@github.com:LuaCATS/busted.git .dependencies/busted 2>/dev/null || true
	git clone git@github.com:LuaCATS/luassert.git .dependencies/luassert 2>/dev/null || true

# Run busted tests
test:
	@command -v busted >/dev/null 2>&1 && busted . \
		|| (eval "$$(luarocks path --bin --lua-version 5.1)" && busted .)

# Run luacheck linter
lint:
	luacheck lua plugin spec

luacheck:
	luacheck lua plugin spec

# Auto-format Lua files
format:
	stylua lua plugin spec

# Check formatting and lint (CI-friendly)
check: lint
	stylua --check lua plugin spec

# Generate API documentation via mega.vimdoc
api-documentation:
	nvim -u scripts/make_api_documentation/minimal_init.lua \
		-l scripts/make_api_documentation/main.lua

# Run lua-language-server type checking
llscheck: download-dependencies
	VIMRUNTIME="$$(nvim --clean --headless --cmd 'lua io.write(os.getenv("VIMRUNTIME"))' --cmd 'quit')" \
		llscheck --configpath $(CONFIGURATION) .

# Generate test coverage report
coverage-html:
	nvim -u NONE -U NONE -N -i NONE --headless \
		-c "luafile scripts/luacov.lua" -c "quit"
	luacov --reporter multiple.html

# Check markdown formatting
check-mdformat:
	python -m mdformat --check README.md
