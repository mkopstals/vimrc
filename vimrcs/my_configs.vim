let g:nv_search_paths = ['~/vimwiki']

noremap <S-h> :tabprevious<cr>
noremap <S-l> :tabnext<cr>

let NERDTreeShowHidden=1

set tags=./tags;/

let g:ctrlp_extensions = ['tag']
let g:ctrlp_prompt_mappings = { 'PrtBS()':              ['<bs>', '<c-b>'] }


let g:jedi#use_tabs_not_buffers = 1

let g:ackprg = 'ag --nogroup --nocolor --column'

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

set rtp+=/usr/local/opt/fzf


let b:ale_fixers = {'python': ['black']}
