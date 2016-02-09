

if exists("g:loaded_hunter_autoload")
    finish
endif
let g:loaded_hunter_autoload = 1


call hunter#loadFiles()
call hunter#ui_glue#setupCommands()




