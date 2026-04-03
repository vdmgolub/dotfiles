function al --wraps='aws sso login --sso-session infracost' --description 'alias al=aws sso login --sso-session infracost'
  aws sso login --sso-session infracost $argv
        
end
