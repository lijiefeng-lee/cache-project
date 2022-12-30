<?php
/**
 * Created by PhpStorm.
 * User: Sixstar-Peter
 * Date: 2019/12/11
 * Time: 22:13
 */

$redis=new \RedisCluster(null,["118.24.109.254:6390","118.24.109.254:6391","118.24.109.254:6392","118.24.109.254:6393"],$timeout = null, $readTimeout = null, $persistent = false,"sixstar");

//$res=$redis->xRead(['mystream' => '$'], 1, 0);
//业务逻辑

$res=$redis->xdel("mystream",["1576074342694-0"]);


var_dump($res);