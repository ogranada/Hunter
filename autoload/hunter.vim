

if exists("g:hunter_load_files")
    finish
endif
let g:hunter_load_files = 1

function! hunter#loadFiles()
    runtime lib/hunter.vim
    runtime plugin/hunter/ui_glue.vim
endfunction




