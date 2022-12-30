<?php
/**
 * Created by PhpStorm.
 * User: Sixstar-Peter
 * Date: 2019/12/11
 * Time: 21:03
 */

$redis=new \RedisCluster(null,["118.24.109.254:6390","118.24.109.254:6391","118.24.109.254:6392","118.24.109.254:6393"],$timeout = null,0, true,"sixstar");
$redis->publish("cacheUpdate","xxxxx");



//$redis->publish("sixstar:news","xxxxx");
//$redis->publish("sixstar:music","xxxxx");