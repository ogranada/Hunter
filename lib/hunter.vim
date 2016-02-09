
function! UpdatePackagesFile(package, description)
python << EOF
    
import vim
import os

try:
    package = vim.eval("a:package")
    description = vim.eval("a:description")
    os.system('''echo '" %s' >> ~/.sweet_user_bundles.vim ''', description)
except Exception as w:
    print w
EOF
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
                let l:confirm = input(printf('Do you want install "%s"? [N/y]: ', item.full_name))
                if l:confirm == 'y' || l:confirm == 'Y'
                    let l:rtpname = printf('Bundle ''%s'' ',item.full_name)
                    let l:pname = printf('"Bundle ''%s''"', item.full_name)
                    "execute '!' 'printf' l:pname '>>' '~/.sweet_user_bundles.vim'
                    let pending = printf('! printf %s >> ~/.sweet_user_bundles.vim', l:pname)
                    call RunCommand(pending)
                    "execute l:rtpname
                    "execute 'PluginInstall'
                endif
            endif
            let l:counter += 1
        endfor
    else
        echo printf('No packages found for %s', a:1)
    endif
endfunction

