" Unicode Haskell for Vim
" Based on Haskell Cuteness by Andrey Popp <andrey.popp@braintrace.ru>

let s:mappedChars = {
  \ '\\': 'λ',
  \ '<-': '←',
  \ '->': '→',
  \ '<=': '≲',
  \ '>=': '≳',
  \ '==': '≡',
  \ '/=': '≠',
  \ '=>': '⇒',
  \ '>>': '»',
  \ '. ': '∙ ',
  \ 'forall ': '∀'
  \ }

" Turn entered text into Unicode characters if possible
for [key, value] in items(s:mappedChars)
    exec "imap <buffer>" key value
endfor

" Turn syntax highlight on for new symbols
syn match hsVarSym "(\|λ\|←\|→\|≲\|≳\|≡\|≠\| )"

if exists("s:loaded_unihaskell")
    finish
endif
let s:loaded_unihaskell = 1

augroup HaskellC
    autocmd BufReadPost *.hs cal s:HaskellSrcToUTF8()
    autocmd BufWritePre *.hs cal s:UTF8ToHaskellSrc()
    autocmd BufWritePost *.hs cal s:HaskellSrcToUTF8()
augroup END

" function to convert ''fancy haskell source'' to haskell source
function s:UTF8ToHaskellSrc()
    let s:line = line(".")
    let s:column = col(".")

    silent %s/λ/\\/eg
    silent %s/←/<-/eg
    silent %s/→/->/eg
    silent %s/≲/<=/eg
    silent %s/≳/>=/eg
    silent %s/≡/==/eg
    silent %s/≠/\/=/eg
    silent %s/⇒/=>/eg
    silent %s/»/>>/eg
    silent %s/∙ /. /eg
    silent %s/∀/forall /eg


    let &l:fileencoding = s:oldencoding
    call cursor(s:line,s:column)
endfunction

" function to convert haskell source to ''fancy haskell source''
function s:HaskellSrcToUTF8()
    let s:line = line(".")
    let s:column = col(".")

    let s:oldencoding = &l:fileencoding
    set fileencoding=utf-8

    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<=\\\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/λ\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<=->\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/→\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<=<-\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/←\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<=<=\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/≲\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<=>=\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/≳\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<===\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/≡\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<=\/=\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/≠\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<==>\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/⇒\1/eg
    silent %s/[^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>?@\^|~.]\@<=>>\([^λ←→≲≳≡≠⇒»∙∀\\\-!#$%&*+/<=>\?@\^|~.]\)/»\1/eg
    silent %s/forall /∀/eg
    silent %s/ \@<=\. /∙ /eg

    let &l:fileencoding = s:oldencoding
    call cursor(s:line,s:column)
endfunction

do HaskellC BufRead
