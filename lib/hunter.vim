
function! CheckIfIsInstalled(package)
    if !has('python')
        echo "Error: Required vim compiled with +python"
        finish
    endif
    if !exists("g:hunt_target_file")
        let g:hunt_target_file = "~/.user_bundles.vim"
    endif
python << EOF
import vim
import os
from os.path import expanduser
try:
    package = vim.eval("a:package")
    target = vim.eval("g:hunt_target_file")
    vim.command("let l:package_installed = 0")
    with open(expanduser(target), 'r') as bundles:
        data = bundles.read()
        if package in data:
            vim.command("let l:package_installed = 1")
except Exception as w:
    print w
EOF
    return l:package_installed
endfunction

function! UpdatePackagesFile(package, description)
    if !has('python')
        echo "Error: Required vim compiled with +python"
        finish
    endif
    if !exists("g:hunt_target_file")
        let g:hunt_target_file = "~/.user_bundles.vim"
    endif
python << EOF
import vim
import os
try:
    package = vim.eval("a:package")
    description = vim.eval("a:description")
    target = vim.eval("g:hunt_target_file")
    command = '''echo '\n" %s' >> %s '''%(description, target)
    os.system(command)
    command = '''echo "Bundle '%s'\n" >> %s '''%(package, target)
    os.system(command)
    vim.command("let l:package_installed = 1")
except Exception as w:
    print w
    vim.command("let l:package_installed = 0")
EOF
    if l:package_installed
        echo 'Package Installed, press INTRO to continue'
    endif
endfunction

function! hunter#FindInFiles(...)
    let l:queryString = printf('https://api.github.com/search/repositories?q=vim+%s+language:VImL&sort=stars&order=desc', substitute(a:1, ' ', '%20', ''))
    let res = webapi#http#get(queryString)
    let obj = webapi#json#decode(res.content)
    if obj.total_count > 0
        echohl Title
        echo 'List of packages:'
        echohl None
        let l:counter = 1
        for item in obj.items
            echo printf("%d. %s\t\t\t%s", l:counter, item.full_name, item.description)
            let l:counter += 1
        endfor
        let l:choice = input('Choose a package number: ')
        while l:choice == ''
            echo 'Invalid package number.'
            let l:choice = input('Choose a package number: ')
        endwhile
        echo ' '
        let l:counter = 1
        echo ' '
        for item in obj.items
            if l:counter<=obj.total_count && l:counter == l:choice
                if CheckIfIsInstalled(item.full_name)
                    echo "Package already installed."
                    return 0
                endif
                let l:confirm = input(printf('Do you want install "%s"? [N/y]: ', item.full_name))
                if l:confirm == 'y' || l:confirm == 'Y'
                    let l:rtpname = printf('Bundle ''%s'' ',item.full_name)
                    let l:pname = printf('"Bundle ''%s''"', item.full_name)
                    call UpdatePackagesFile(item.full_name, item.description)
                    execute l:rtpname
                    execute 'PluginInstall'
                endif
            endif
            let l:counter += 1
        endfor
    else
        echo printf('No packages found for %s', a:1)
    endif
endfunction

