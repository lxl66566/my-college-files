add_rules("mode.debug", "mode.release")

local xram_size = 0
local iram_size = 256
local code_size = 8192

set_languages("c99")

target("xmake_c51")
add_ldflags("--model-small")
add_ldflags("--xram-size " .. xram_size)
add_ldflags("--iram-size " .. iram_size)
add_ldflags("--code-size " .. code_size)
add_ldflags("--opt-code-size")
set_kind("binary")
add_files("src/*.c")

task("dl")
on_run(function()
	os.run("objcopy -I ihex -O binary build/mcs51/mcs51/release/xmake_c51.bin build/c51.bin");
	os.run(
		"sudo poetry run stcgal -P stc89 -b 9600 build/c51.bin",
		{ stdout = outfile, stderr = errfile }
	)
end)
set_menu({
	-- 设置菜单用法
	usage = "xmake dl",
})
