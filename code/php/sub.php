<?php
/**
 * Created by PhpStorm.
 * User: Sixstar-Peter
 * Date: 2019/12/11
 * Time: 21:03
 */

$redis=new \RedisCluster(null,["118.24.109.254:6390","118.24.109.254:6391","118.24.109.254:6392","118.24.109.254:6393"],$timeout = null,0, true,"sixstar");

//$redis->subscribe(["cacheUpdate"],function($obj,$channel,$msg){
//    var_dump($obj,$channel,$msg);
//});

$redis->psubscribe(["sixstar:*"],function($obj,$channelRule,$channel,$msg){
    var_dump($obj,$channelRule,$channel,$msg);
});