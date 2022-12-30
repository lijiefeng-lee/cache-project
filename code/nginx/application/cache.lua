local key=ngx.re.match(ngx.var.request_uri,"/([0-9]+).html")
local mlcache= require "resty.mlcache"
local common= require "resty.common"
local template = require "resty.template"

-- L3的回调
local function fetch_shop(key)
     --利用布隆过滤器判断
     if (common.filter('shop_list',key) == 1 ) then
          -- redis当中是否有值
          local cacheData=common.read('product_image_'..key)
          if cacheData ~= ngx.null then
               ngx.say("redis exists")
               return cacheData
          end
          --最后才到源服务器去取
          local content=common.send('/producer.php?method=updateCacheImage&id='..key)
          if content == ngx.null then
                return
          end
          return content
     end
     return
end

if type(key) == "table" then
      local cache,err=mlcache.new("cache_name","my_cache",{
            lru_size = 500, --设置的缓存的个数
            ttl = 5, --缓存过期时间
            neg_ttl = 6, --L3返回nil的保存时间
            ipc_shm = "ipc_cache" --用于将L2的缓存设置到L1
      })
      if not cache then
        ngx.log(ngx.ERR,"缓存创建失败",err)
      end
      --ngx.say(key[1])
      local shop_detail,err,level=cache:get(key[1],nil,fetch_shop,key[1])
      -- 刷新
      if  level == 3 then
         --ngx.say(shop_detail)
          math.randomseed(tostring(os.time()))
          local expire_time =math.random(1,6)
          cache:set(key[1],{ttl = expire_time},shop_detail)
      end
      ngx.say(shop_detail)

       --[[
          template.render("index.html",{
               title = "peter的商城",
               category = {"首页","团购促销","名师荟萃","艺品驿站","欧式摆件"},
               info   ={"xxx"},
               shop = {"xxx"}
          })
      ]]
end
