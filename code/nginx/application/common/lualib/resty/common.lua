local common={}
function common.filter(key,val)
    local red_c=ngx.ctx.redisObject
    --在redis当中嵌入lua脚本
     local res,err = red_c:eval([[
             local  key=KEYS[1]
             local  val= ARGV[1]
             local  res,err=redis.call('bf.exists',key,val)
             return res
            -- 业务逻辑
     ]],1,key,val)
     if  err then
        ngx.log(ngx.ERR,"过滤错误:",err)
        return false
     end
     return res
end
function common.send(url)
     local req_data
     local method = ngx.var.request.method
     if method == "POST" then
         req_data={method = ngx.HTTP_POST,body = ngx.req.read_body() }
     elseif method == "PUT" then
         req_data={method = ngx.HTTP_PUT, body = ngx.req.read_body() }
     else
         req_data={method = ngx.HTTP_GET}
     end
     local uri=ngx.var.request.uri
     if uri== nil then
           uri=''
     end
     ngx.say(url..uri)
     local res,err=ngx.location.capture(
         url..uri,
         req_data
     )
     if res.status == 200 then
         return res.body
     end
     return
end

function common.read(key)
    local red_c=ngx.ctx.redisObject

    local res,err=red_c:get(key)
    if err then
       ngx.log(ngx.ERR,"获取数据失败:",err)
       return
    end
    return res

end

return common

