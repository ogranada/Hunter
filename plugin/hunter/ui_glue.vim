

if exists("g:loaded_hunter_ui_glue_autoload")
    finish
endif
let g:loaded_hunter_ui_glue_autoload = 1

function! hunter#ui_glue#setupCommands()
    command! -nargs=+ Hunt :call hunter#FindInFiles(<q-args>)
    "command! -complete=file -nargs=1 Vplay :call hunter#Play(<q-args>)
    "command! -nargs=0 Vstop    :call hunter#Stop()
    "command! -nargs=0 Vskip    :call hunter#Skip()
    "command! -nargs=0 Vpause   :call hunter#Pause()
    "command! -nargs=0 Vunpause :call hunter#Unpause()
    "command! -nargs=0 Vp       :call hunter#SwapPause()
    "command! -nargs=0 Va       :call hunter#Playing()
    "command! -nargs=0 Vactual  :call hunter#Playing()
endfunction



