# https://superuser.com/questions/1158395/combining-functions-in-fish
function ll --description "Tree function"
    if test -n "$argv[1]"
        l --tree "$argv[1]" | bat --number
    else
        l --tree | bat --number
    end
end
