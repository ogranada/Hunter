

if exists("g:loaded_hunter_ui_glue_autoload")
    finish
endif
let g:loaded_hunter_ui_glue_autoload = 1

function! hunter#ui_glue#setupCommands()
    command! -nargs=+ Hunt :call hunter#FindInFiles(<q-args>)
endfunction



